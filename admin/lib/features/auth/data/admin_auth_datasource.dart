import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class AdminAuthDataSource {
  AdminAuthDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw Exception('Sign in failed.');
    }
    return user;
  }

  Future<void> signOut() => _auth.signOut();

  Future<bool> isAdminUser(String uid) async {
    final doc = await _firestore.collection(CollectionNames.users).doc(uid).get();
    if (!doc.exists) return false;
    final data = doc.data() ?? {};
    if (data['isAdmin'] is bool) {
      return data['isAdmin'] as bool;
    }
    return data['role'] == 'admin';
  }
}
