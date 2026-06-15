import 'package:bazaar/features/profile/data/datasources/account_deletion_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountDeletionDataSourceProvider =
    Provider<AccountDeletionDataSource>((ref) {
  return AccountDeletionDataSource();
});

final isGoogleAccountProvider = FutureProvider.autoDispose<bool>((ref) async {
  return ref.watch(accountDeletionDataSourceProvider).isGoogleAccount();
});

class AccountDeletionController {
  AccountDeletionController(this._dataSource);

  final AccountDeletionDataSource _dataSource;

  Future<bool> isGoogleAccount() => _dataSource.isGoogleAccount();

  Future<void> deleteAccount({
    required String uid,
    String? password,
    bool useGoogle = false,
  }) async {
    try {
      if (useGoogle) {
        await _dataSource.reauthenticateWithGoogle();
      } else {
        if (password == null || password.isEmpty) {
          throw const AccountDeletionException('Password is required.');
        }
        await _dataSource.reauthenticateWithPassword(password);
      }

      await _dataSource.deleteAccountData(uid);
      await _dataSource.deleteAuthUser();
    } on FirebaseAuthException catch (error) {
      throw AccountDeletionException(_mapAuthError(error));
    } on AccountDeletionException {
      rethrow;
    } catch (error) {
      throw AccountDeletionException(
        error is AccountDeletionException
            ? error.message
            : 'Failed to delete account. Please try again.',
      );
    }
  }

  String _mapAuthError(FirebaseAuthException error) {
    return switch (error.code) {
      'wrong-password' || 'invalid-credential' => 'Incorrect password.',
      'requires-recent-login' =>
        'Please re-authenticate and try again.',
      'user-mismatch' => 'Re-authentication failed. Please try again.',
      _ => error.message ?? 'Authentication failed.',
    };
  }
}

final accountDeletionControllerProvider =
    Provider<AccountDeletionController>((ref) {
  return AccountDeletionController(
    ref.watch(accountDeletionDataSourceProvider),
  );
});
