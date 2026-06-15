import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:admin/features/users/data/admin_users_datasource.dart';
import 'package:admin/features/users/presentation/providers/admin_users_provider.dart';
import 'package:admin/features/users/presentation/widgets/user_detail_panel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  UserModel? _detailUser;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.str;
    final usersAsync = ref.watch(adminUsersProvider);

    return usersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(s.errorWithDetails('$error'))),
      data: (users) {
        final filtered = filterUsersByQuery(users, _searchQuery);

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: s.searchByNameOrEmail,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 900,
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.shade100,
                      ),
                      columns: [
                        const DataColumn2(label: Text(''), fixedWidth: 56),
                        DataColumn2(label: Text(s.nameLabel), size: ColumnSize.L),
                        DataColumn2(label: Text(s.email), size: ColumnSize.L),
                        DataColumn2(label: Text(s.joined), size: ColumnSize.S),
                        DataColumn2(
                          label: Text(s.listingsCount),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(label: Text(s.status), size: ColumnSize.S),
                        DataColumn2(label: Text(s.actions), fixedWidth: 200),
                      ],
                      rows: filtered.map((user) {
                        final joined =
                            DateFormat.yMMMd().format(user.createdAt);
                        final banned = userIsBanned(user);

                        return DataRow2(
                          color: WidgetStateProperty.all(
                            banned ? Colors.red.shade50 : null,
                          ),
                          cells: [
                            DataCell(_UserAvatar(user: user)),
                            DataCell(Text(user.displayName)),
                            DataCell(Text(user.email)),
                            DataCell(Text(joined)),
                            DataCell(Text('${user.listingCount}')),
                            DataCell(
                              banned
                                  ? Text(
                                      s.banned,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Text(s.active),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        setState(() => _detailUser = user),
                                    child: Text(s.view),
                                  ),
                                  if (banned)
                                    TextButton(
                                      onPressed: () => _unban(user),
                                      child: Text(s.unbanUser),
                                    )
                                  else
                                    TextButton(
                                      onPressed: () => _ban(user),
                                      child: Text(
                                        s.banUser,
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            if (_detailUser != null)
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _detailUser = null),
                        child: Container(color: Colors.black26),
                      ),
                    ),
                    SizedBox(
                      width: 380,
                      child: UserDetailPanel(
                        user: _detailUser!,
                        onClose: () => setState(() => _detailUser = null),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _ban(UserModel user) async {
    final s = ref.str;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.banUserTitle),
        content: Text(s.banUserAdminConfirm(user.displayName, user.email)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.banUser),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await ref.read(adminUsersControllerProvider).setBanned(
          userId: user.id,
          banned: true,
        );
  }

  Future<void> _unban(UserModel user) async {
    await ref.read(adminUsersControllerProvider).setBanned(
          userId: user.id,
          banned: false,
        );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundImage:
          user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
      child: user.photoUrl == null
          ? Text(
              user.displayName.isNotEmpty
                  ? user.displayName[0].toUpperCase()
                  : '?',
            )
          : null,
    );
  }
}
