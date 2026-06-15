import 'package:bazaar/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> authStateChanges();

  Future<UserEntity?> getCurrentUser();

  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<UserEntity> signInWithGoogle();

  Future<void> signOut();

  Future<UserEntity?> getUserById(String userId);

  Future<UserEntity> updateProfile({
    required String userId,
    required String displayName,
    String? phone,
  });
}
