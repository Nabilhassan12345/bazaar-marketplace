import 'package:bazaar/features/auth/presentation/providers/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn;

  static const _webClientId =
      '495058275787-4ue0hjtl6huaet873t7raook0luadh0h.apps.googleusercontent.com';

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn? _googleSignIn;

  GoogleSignIn get _googleSignInInstance => _googleSignIn ??
      GoogleSignIn(clientId: kIsWeb ? _webClientId : null);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore
        .collection(CollectionNames.users)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw const AuthException('Sign in failed. Please try again.');
    }
    return _loadOrCreateProfile(user);
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw const AuthException('Sign up failed. Please try again.');
    }

    await user.updateDisplayName(displayName.trim());
    return _createUserProfile(
      user: user,
      displayName: displayName.trim(),
    );
  }

  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _googleSignInInstance.signIn();
    if (googleUser == null) {
      throw const AuthException('Google sign in was cancelled.');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    final user = result.user;
    if (user == null) {
      throw const AuthException('Google sign in failed.');
    }

    return _loadOrCreateProfile(
      user,
      displayName: user.displayName ?? 'Bazaar User',
      photoUrl: user.photoURL,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (_googleSignIn != null || kIsWeb) {
      await _googleSignInInstance.signOut();
    }
  }

  Future<UserModel> updateUserProfile({
    required String userId,
    required String displayName,
    String? phone,
  }) async {
    final updates = <String, dynamic>{
      'displayName': displayName.trim(),
      'updatedAt': Timestamp.now(),
    };

    if (phone != null && phone.trim().isNotEmpty) {
      updates['phone'] = phone.trim();
    } else {
      updates['phone'] = FieldValue.delete();
    }

    await _firestore.collection(CollectionNames.users).doc(userId).update(updates);

    final currentUser = _auth.currentUser;
    if (currentUser != null && currentUser.uid == userId) {
      await currentUser.updateDisplayName(displayName.trim());
    }

    final profile = await getUserProfile(userId);
    if (profile == null) {
      throw const AuthException('Profile not found.');
    }
    return profile;
  }

  String mapFirebaseError(FirebaseAuthException error) {
    return switch (error.code) {
      'email-already-in-use' => 'This email is already registered.',
      'invalid-email' => 'Please enter a valid email address.',
      'weak-password' => 'Password must be at least 6 characters.',
      'user-not-found' || 'wrong-password' || 'invalid-credential' =>
        'Invalid email or password.',
      'user-disabled' => 'This account has been disabled.',
      _ => error.message ?? 'Authentication failed.',
    };
  }

  Future<UserModel> _loadOrCreateProfile(
    User user, {
    String? displayName,
    String? photoUrl,
  }) async {
    final existing = await getUserProfile(user.uid);
    if (existing != null) {
      if (existing.isBlocked) {
        await signOut();
        throw const AuthException('Your account has been blocked.');
      }
      return existing;
    }

    return _createUserProfile(
      user: user,
      displayName: displayName ?? user.displayName ?? 'Bazaar User',
      photoUrl: photoUrl ?? user.photoURL,
    );
  }

  Future<UserModel> _createUserProfile({
    required User user,
    required String displayName,
    String? photoUrl,
  }) async {
    final profile = UserModel.newUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: displayName,
      photoUrl: photoUrl,
      emailVerified: user.emailVerified,
    );

    await _firestore
        .collection(CollectionNames.users)
        .doc(user.uid)
        .set(profile.toFirestore());

    return profile;
  }
}
