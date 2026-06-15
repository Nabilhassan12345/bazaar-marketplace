import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/home/presentation/widgets/category_chips.dart';
import 'package:bazaar/features/listings/presentation/providers/home_feed_provider.dart';
import 'package:bazaar/features/listings/presentation/providers/home_feed_state.dart';
import 'package:bazaar/features/favorites/presentation/widgets/favorite_listing_card.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
      ref.read(homeFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(homeFeedProvider);
    final notifier = ref.read(homeFeedProvider.notifier);
    final s = ref.str;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            onPressed: () => context.pushNamed(RouteKeys.categories),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          CategoryChips(
            selectedCategory: feed.selectedCategory,
            onCategorySelected: notifier.setCategory,
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(feed, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(HomeFeedState feed, HomeFeedNotifier notifier) {
    final s = ref.str;

    if (feed.isInitialLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: ListingCard(isLoading: true, listing: null),
        ),
      );
    }

    if (feed.errorMessage != null && feed.listings.isEmpty) {
      return ErrorStateView(
        message: feed.errorMessage!,
        onRetry: notifier.loadInitial,
      );
    }

    if (feed.listings.isEmpty) {
      return RefreshIndicator(
        onRefresh: notifier.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            EmptyStateView(
              icon: Icons.inventory_2_outlined,
              title: s.noListings,
              message: s.homeEmptyHint,
              actionLabel: s.postAnAd,
              onAction: () => context.goNamed(RouteKeys.post),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: feed.listings.length +
            (feed.isLoadingMore ? 1 : 0) +
            (feed.errorMessage != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (feed.errorMessage != null && index == feed.listings.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                feed.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            );
          }

          if (index >= feed.listings.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final listing = feed.listings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FavoriteListingCard(
              listing: listing,
              onTap: () => context.pushNamed(
                RouteKeys.listingDetail,
                pathParameters: {'id': listing.id},
              ),
            ),
          );
        },
      ),
    );
  }
}
