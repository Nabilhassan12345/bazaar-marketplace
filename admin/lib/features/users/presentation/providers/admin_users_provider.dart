import 'package:admin/features/users/data/admin_users_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

final adminUsersDataSourceProvider = Provider<AdminUsersDataSource>((ref) {
  return AdminUsersDataSource();
});

final adminUsersProvider = FutureProvider.autoDispose<List<UserModel>>((ref) async {
  return ref.watch(adminUsersDataSourceProvider).fetchAllUsers();
});

class AdminUsersController {
  AdminUsersController(this._dataSource, this._ref);

  final AdminUsersDataSource _dataSource;
  final Ref _ref;

  Future<void> setBanned({
    required String userId,
    required bool banned,
  }) async {
    await _dataSource.setBanned(userId: userId, banned: banned);
    _ref.invalidate(adminUsersProvider);
  }
}

final adminUsersControllerProvider = Provider<AdminUsersController>((ref) {
  return AdminUsersController(ref.watch(adminUsersDataSourceProvider), ref);
});

List<UserModel> filterUsersByQuery(List<UserModel> users, String query) {
  final trimmed = query.trim().toLowerCase();
  if (trimmed.isEmpty) return users;

  return users.where((user) {
    return user.displayName.toLowerCase().contains(trimmed) ||
        user.email.toLowerCase().contains(trimmed);
  }).toList();
}
