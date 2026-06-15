import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/favorites/presentation/widgets/favorite_listing_card.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:bazaar/features/search/presentation/providers/search_provider.dart';
import 'package:bazaar/features/search/presentation/providers/search_state.dart';
import 'package:bazaar/features/search/presentation/widgets/active_filter_chips.dart';
import 'package:bazaar/features/search/presentation/widgets/recent_searches_chips.dart';
import 'package:bazaar/features/search/presentation/widgets/search_bar_widget.dart';
import 'package:bazaar/features/search/presentation/widgets/search_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_shared/l10n/bazaar_strings.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    _focusNode.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(searchProvider.notifier).loadMore();
    }
  }

  void _openFilters() {
    final state = ref.read(searchProvider);
    showSearchFilterSheet(
      context: context,
      initialFilters: state.filters,
      onApply: ref.read(searchProvider.notifier).applyFilters,
      onClearAll: ref.read(searchProvider.notifier).clearFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);
    final s = ref.str;
    final languageCode = ref.watch(localeProvider).code;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.navSearch),
        actions: [
          Badge(
            isLabelVisible: searchState.activeFilterCount > 0,
            label: Text('${searchState.activeFilterCount}'),
            child: IconButton(
              icon: const Icon(Icons.tune),
              tooltip: s.filters,
              onPressed: _openFilters,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBarWidget(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: notifier.setQuery,
              onClear: () {
                _controller.clear();
                notifier.clearQuery();
                _focusNode.requestFocus();
              },
            ),
          ),
          if (searchState.activeFilterCount > 0 && !searchState.showRecentSearches)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ActiveFilterChips(
                filters: searchState.filters.localizedActiveFilters(s, languageCode),
                onRemove: notifier.removeFilter,
              ),
            ),
          Expanded(child: _buildContent(searchState, notifier, s, languageCode)),
        ],
      ),
    );
  }

  Widget _buildContent(
    SearchState state,
    SearchNotifier notifier,
    BazaarStrings s,
    String languageCode,
  ) {
    if (state.showRecentSearches) {
      return ListView(
        children: [
          RecentSearchesChips(
            searches: state.recentSearches,
            onTap: (query) {
              _controller.text = query;
              notifier.searchFromChip(query);
            },
            onRemove: notifier.removeRecentSearch,
          ),
          if (state.recentSearches.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(Icons.search, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    s.searchEmptyHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    if (state.status == SearchStatus.loading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: ListingCard(isLoading: true, listing: null),
        ),
      );
    }

    if (state.status == SearchStatus.error) {
      return ErrorStateView(onRetry: notifier.retry);
    }

    if (state.status == SearchStatus.empty) {
      return EmptyStateView(
        icon: Icons.search_off,
        title: s.noListingsFoundFor(state.activeQuery),
      );
    }

    final resultLabel = s.resultCountLabel(
      state.listings.length,
      hasMore: state.hasMore,
    );

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.listings.length +
          (resultLabel.isNotEmpty ? 1 : 0) +
          (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              resultLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        final listingIndex = index - 1;
        if (listingIndex >= state.listings.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final listing = state.listings[listingIndex];
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
    );
  }
}
