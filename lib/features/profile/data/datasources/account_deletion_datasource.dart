import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class AccountDeletionDataSource {
  AccountDeletionDataSource({
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

  Future<bool> isGoogleAccount() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((info) => info.providerId == 'google.com');
  }

  Future<void> reauthenticateWithPassword(String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AccountDeletionException('No signed-in user.');
    }
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw const AccountDeletionException(
        'This account has no email. Use Google to re-authenticate.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> reauthenticateWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AccountDeletionException('No signed-in user.');
    }

    final googleUser = await _googleSignInInstance.signIn();
    if (googleUser == null) {
      throw const AccountDeletionException('Google re-authentication was cancelled.');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> deleteAccountData(String uid) async {
    await _deleteAllListings(uid);
    await _deleteAllFavorites(uid);
    await _firestore.collection(CollectionNames.users).doc(uid).delete();
  }

  Future<void> deleteAuthUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AccountDeletionException('No signed-in user.');
    }
    await user.delete();
  }

  Future<void> _deleteAllListings(String uid) async {
    final snapshot = await _firestore
        .collection(CollectionNames.listings)
        .where('sellerId', isEqualTo: uid)
        .get();

    await _batchDelete(snapshot.docs.map((doc) => doc.reference));
  }

  Future<void> _deleteAllFavorites(String uid) async {
    final snapshot = await _firestore
        .collection(CollectionNames.favorites)
        .doc(uid)
        .collection('items')
        .get();

    await _batchDelete(snapshot.docs.map((doc) => doc.reference));
  }

  Future<void> _batchDelete(Iterable<DocumentReference<Map<String, dynamic>>> refs) async {
    final references = refs.toList();
    for (var i = 0; i < references.length; i += 500) {
      final batch = _firestore.batch();
      final chunk = references.skip(i).take(500);
      for (final ref in chunk) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }
}

class AccountDeletionException implements Exception {
  const AccountDeletionException(this.message);

  final String message;

  @override
  String toString() => message;
}
