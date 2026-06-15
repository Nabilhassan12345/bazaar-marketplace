import 'package:admin/features/auth/data/admin_auth_datasource.dart';
import 'package:admin/features/auth/domain/admin_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminAuthDataSourceProvider = Provider<AdminAuthDataSource>((ref) {
  return AdminAuthDataSource();
});

final adminSessionProvider = StreamProvider<AdminSession>((ref) async* {
  final dataSource = ref.watch(adminAuthDataSourceProvider);

  await for (final user in dataSource.authStateChanges()) {
    if (user == null) {
      yield const AdminSession.unauthenticated();
      continue;
    }

    yield const AdminSession.loading();

    final isAdmin = await dataSource.isAdminUser(user.uid);
    if (!isAdmin) {
      yield const AdminSession.accessDenied();
    } else {
      yield AdminSession.authenticated(user);
    }
  }
});

class AdminAuthController {
  AdminAuthController(this._dataSource);

  final AdminAuthDataSource _dataSource;

  Future<void> signIn({
    required String email,
    required String password,
  }) =>
      _dataSource.signInWithEmail(email: email, password: password);

  Future<void> signOut() => _dataSource.signOut();
}

final adminAuthControllerProvider = Provider<AdminAuthController>((ref) {
  return AdminAuthController(ref.watch(adminAuthDataSourceProvider));
});
