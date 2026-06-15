import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class UserDetailPanel extends StatelessWidget {
  const UserDetailPanel({
    required this.user,
    required this.onClose,
    super.key,
  });

  final UserModel user;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final joined = DateFormat.yMMMd().format(user.createdAt);

    return Material(
      elevation: 8,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'User Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                      child: user.photoUrl == null
                          ? Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(fontSize: 28),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'Name', value: user.displayName),
                  _InfoRow(label: 'Email', value: user.email),
                  _InfoRow(label: 'Joined', value: joined),
                  _InfoRow(label: 'Listings', value: '${user.listingCount}'),
                  _InfoRow(label: 'Role', value: user.role.value),
                  _InfoRow(
                    label: 'Status',
                    value: user.isBlocked ? 'Banned' : 'Active',
                  ),
                  if (user.phone != null) _InfoRow(label: 'Phone', value: user.phone!),
                  if (user.bio != null && user.bio!.isNotEmpty)
                    _InfoRow(label: 'Bio', value: user.bio!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
