import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingListingsPage extends ConsumerWidget {
  const PendingListingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    return Center(
      child: Text(s.listingsManagementSoon),
    );
  }
}
