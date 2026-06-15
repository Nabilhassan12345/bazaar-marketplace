import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/favorites/presentation/providers/favorites_feed_provider.dart';
import 'package:bazaar/features/favorites/presentation/providers/favorites_feed_state.dart';
import 'package:bazaar/features/favorites/presentation/widgets/favorite_listing_card.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(favoritesFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(favoritesFeedProvider);
    final notifier = ref.read(favoritesFeedProvider.notifier);
    final s = ref.str;

    return Scaffold(
      appBar: AppBar(title: Text(s.savedItems)),
      body: _buildBody(feed, notifier),
    );
  }

  Widget _buildBody(FavoritesFeedState feed, FavoritesFeedNotifier notifier) {
    final s = ref.str;

    if (feed.isInitialLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => const ListingCard(isLoading: true, listing: null),
      );
    }

    if (feed.errorMessage != null && feed.listings.isEmpty) {
      return ErrorStateView(
        message: feed.errorMessage!,
        onRetry: notifier.loadInitial,
      );
    }

    if (feed.listings.isEmpty) {
      return EmptyStateView(
        icon: Icons.favorite_border,
        title: s.noSavedListings,
        message: s.noFavoritesHint,
        actionLabel: s.browse,
        onAction: () => context.goNamed(RouteKeys.home),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: feed.listings.length + (feed.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= feed.listings.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final listing = feed.listings[index];
        return FavoriteListingCard(
          listing: listing,
          onTap: () => context.pushNamed(
            RouteKeys.listingDetail,
            pathParameters: {'id': listing.id},
          ),
        );
      },
    );
  }
}
