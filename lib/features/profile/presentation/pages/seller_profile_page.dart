import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/blocks/presentation/providers/block_providers.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:bazaar/features/reports/presentation/widgets/report_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final sellerListingsProvider =
    FutureProvider.autoDispose.family<List<ListingEntity>, String>((ref, userId) async {
  final page =
      await ref.watch(listingRepositoryProvider).getApprovedListingsBySeller(userId);
  return page.listings;
});

class SellerProfilePage extends ConsumerWidget {
  const SellerProfilePage({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateChangesProvider).valueOrNull;
    final isOwnProfile = currentUser?.id == userId;
    final profileAsync = ref.watch(userProfileProvider(userId));
    final listingsAsync = ref.watch(sellerListingsProvider(userId));
    final blockedIds = ref.watch(blockedUserIdsProvider).valueOrNull ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Profile'),
        actions: [
          if (!isOwnProfile)
            PopupMenuButton<String>(
              onSelected: (value) async {
                final owner = profileAsync.valueOrNull;
                if (owner == null) return;

                switch (value) {
                  case 'report':
                    await showReportUserSheet(
                      context,
                      reportedUserId: userId,
                    );
                  case 'block':
                    await _confirmBlock(context, ref, owner.displayName);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'report',
                  child: Text('Report this seller'),
                ),
                PopupMenuItem(
                  value: 'block',
                  enabled: !blockedIds.contains(userId),
                  child: Text(
                    blockedIds.contains(userId) ? 'Blocked' : 'Block this user',
                  ),
                ),
              ],
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ListingCard(isLoading: true, listing: null),
            SizedBox(height: 12),
            ListingCard(isLoading: true, listing: null),
          ],
        ),
        error: (error, _) => ErrorStateView(
          onRetry: () => ref.invalidate(userProfileProvider(userId)),
        ),
        data: (owner) {
          if (owner == null) {
            return const Center(child: Text('Seller not found.'));
          }

          final memberSince = DateFormat.yMMMM().format(owner.createdAt);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: owner.photoUrl != null
                        ? NetworkImage(owner.photoUrl!)
                        : null,
                    child: owner.photoUrl == null
                        ? Text(
                            owner.displayName.isNotEmpty
                                ? owner.displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          owner.displayName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Member since $memberSince',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${owner.listingCount} listings',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Listings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              listingsAsync.when(
                loading: () => Column(
                  children: List.generate(
                    2,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: ListingCard(isLoading: true, listing: null),
                    ),
                  ),
                ),
                error: (_, __) => ErrorStateView(
                  onRetry: () => ref.invalidate(sellerListingsProvider(userId)),
                ),
                data: (listings) {
                  if (listings.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.inventory_2_outlined,
                      title: 'No active listings',
                    );
                  }

                  return Column(
                    children: listings.map((listing) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ListingCard(
                          listing: listing,
                          onTap: () => context.push('/listings/${listing.id}'),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmBlock(
    BuildContext context,
    WidgetRef ref,
    String displayName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block $displayName?'),
        content: const Text(
          "Their listings won't appear in your feed.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Block'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(blockedUserIdsProvider.notifier).blockUser(
          blockedUserId: userId,
          blockedDisplayName: displayName,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$displayName blocked')),
      );
    }
  }
}
