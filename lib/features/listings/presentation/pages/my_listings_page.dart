import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:bazaar/features/favorites/presentation/widgets/favorite_listing_card.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_shared/l10n/bazaar_strings.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class MyListingsPage extends ConsumerWidget {
  const MyListingsPage({super.key});

  Future<bool> _confirmDelete(BuildContext context, BazaarStrings s) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.deleteListingTitle),
        content: Text(s.deleteListingMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(s.deleteAction),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _deleteListing(
    WidgetRef ref,
    BuildContext context,
    ListingEntity listing,
    BazaarStrings s,
  ) async {
    final confirmed = await _confirmDelete(context, s);
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(listingRepositoryProvider).deleteListing(
            listingId: listing.id,
            status: listing.status,
          );
      ref.invalidate(myListingsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.listingDeleted)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.listingDeleteFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(myListingsProvider);
    final s = ref.str;

    return Scaffold(
      appBar: AppBar(title: Text(s.myListings)),
      body: listingsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: ListingCard(isLoading: true, listing: null),
          ),
        ),
        error: (error, _) => ErrorStateView(
          onRetry: () => ref.invalidate(myListingsProvider),
        ),
        data: (listings) {
          if (listings.isEmpty) {
            return EmptyStateView(
              icon: Icons.post_add_outlined,
              title: s.noListings,
              message: s.myListingsEmptyHint,
              actionLabel: s.postAnAd,
              onAction: () => context.goNamed(RouteKeys.post),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myListingsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: ValueKey(listing.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white),
                    ),
                    confirmDismiss: (_) => _confirmDelete(context, s),
                    onDismissed: (_) async {
                      try {
                        await ref.read(listingRepositoryProvider).deleteListing(
                              listingId: listing.id,
                              status: listing.status,
                            );
                        ref.invalidate(myListingsProvider);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(s.listingDeleteFailed)),
                          );
                          ref.invalidate(myListingsProvider);
                        }
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FavoriteListingCard(
                          listing: listing,
                          onTap: () => context.pushNamed(
                            RouteKeys.editListing,
                            pathParameters: {'id': listing.id},
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _StatusChip(status: listing.status, strings: s),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => _deleteListing(
                                ref,
                                context,
                                listing,
                                s,
                              ),
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: Text(s.deleteAction),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.strings});

  final ListingStatus status;
  final BazaarStrings strings;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ListingStatus.approved => Colors.green,
      ListingStatus.pendingReview => Colors.amber.shade800,
      ListingStatus.rejected => Colors.red,
      ListingStatus.draft => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        strings.listingStatus(status.value).toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
