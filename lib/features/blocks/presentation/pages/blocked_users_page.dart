import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/blocks/presentation/providers/block_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';
import 'package:shimmer/shimmer.dart';

class BlockedUsersPage extends ConsumerWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final blockedAsync = ref.watch(blockedUsersListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.blockedUsers)),
      body: blockedAsync.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, __) => const _BlockedUserShimmer(),
        ),
        error: (error, _) => ErrorStateView(
          onRetry: () => ref.invalidate(blockedUsersListProvider),
        ),
        data: (blocks) {
          if (blocks.isEmpty) {
            return EmptyStateView(
              icon: Icons.block_outlined,
              title: s.noBlockedUsers,
              message: s.noBlockedUsersHint,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: blocks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _BlockedUserTile(block: blocks[index]);
            },
          );
        },
      ),
    );
  }
}

class _BlockedUserShimmer extends StatelessWidget {
  const _BlockedUserShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const ListTile(
        leading: CircleAvatar(radius: 20),
        title: SizedBox(height: 14, width: 120, child: ColoredBox(color: Colors.white)),
        trailing: SizedBox(height: 32, width: 72, child: ColoredBox(color: Colors.white)),
      ),
    );
  }
}

class _BlockedUserTile extends ConsumerWidget {
  const _BlockedUserTile({required this.block});

  final BlockModel block;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final name = block.blockedDisplayName ?? s.unknownUser;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: TextButton(
        onPressed: () => _unblock(context, ref),
        child: Text(s.unblock),
      ),
    );
  }

  Future<void> _unblock(BuildContext context, WidgetRef ref) async {
    await ref
        .read(blockedUserIdsProvider.notifier)
        .unblockUser(block.blockedUserId);
    ref.invalidate(blockedUsersListProvider);
  }
}
