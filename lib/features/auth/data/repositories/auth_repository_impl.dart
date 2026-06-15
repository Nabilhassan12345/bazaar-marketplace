import 'package:bazaar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bazaar/features/auth/domain/entities/user_entity.dart';
import 'package:bazaar/features/auth/domain/repositories/auth_repository.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<UserEntity?> authStateChanges() {
    return _remoteDataSource.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final profile = await _remoteDataSource.getUserProfile(user.uid);
      return profile == null ? null : UserEntity.fromModel(profile);
    });
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final profile = await _remoteDataSource.getUserProfile(user.uid);
    return profile == null ? null : UserEntity.fromModel(profile);
  }

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final profile = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return UserEntity.fromModel(profile);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_remoteDataSource.mapFirebaseError(error));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Unable to sign in. Please try again.');
    }
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final profile = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return UserEntity.fromModel(profile);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_remoteDataSource.mapFirebaseError(error));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Unable to sign up. Please try again.');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final profile = await _remoteDataSource.signInWithGoogle();
      return UserEntity.fromModel(profile);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_remoteDataSource.mapFirebaseError(error));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Google sign in failed.');
    }
  }

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<UserEntity?> getUserById(String userId) async {
    final profile = await _remoteDataSource.getUserProfile(userId);
    return profile == null ? null : UserEntity.fromModel(profile);
  }

  @override
  Future<UserEntity> updateProfile({
    required String userId,
    required String displayName,
    String? phone,
  }) async {
    try {
      final profile = await _remoteDataSource.updateUserProfile(
        userId: userId,
        displayName: displayName,
        phone: phone,
      );
      return UserEntity.fromModel(profile);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Failed to update profile.');
    }
  }
}
