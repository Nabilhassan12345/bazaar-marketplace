import 'package:bazaar/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteListingCard extends ConsumerWidget {
  const FavoriteListingCard({
    required this.listing,
    this.onTap,
    super.key,
  });

  final ListingEntity listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteIdsProvider);
    final isFavorite = favoriteIds.contains(listing.id);

    return ListingCard(
      listing: listing,
      isFavorite: isFavorite,
      onFavoriteTap: () =>
          ref.read(favoriteIdsProvider.notifier).toggle(listing.id),
      onTap: onTap,
    );
  }
}
