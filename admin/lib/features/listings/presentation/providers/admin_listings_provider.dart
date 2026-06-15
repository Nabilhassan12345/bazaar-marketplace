import 'package:admin/features/listings/data/admin_listings_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

final adminListingsDataSourceProvider = Provider<AdminListingsDataSource>((ref) {
  return AdminListingsDataSource();
});

final adminListingsProvider =
    FutureProvider.autoDispose<List<ListingModel>>((ref) async {
  return ref.watch(adminListingsDataSourceProvider).fetchAllListings();
});

class AdminListingsController {
  AdminListingsController(this._dataSource, this._ref);

  final AdminListingsDataSource _dataSource;
  final Ref _ref;

  Future<void> approve(String listingId) => _updateStatus(
        listingId,
        ListingStatus.approved,
      );

  Future<void> reject(String listingId) => _updateStatus(
        listingId,
        ListingStatus.rejected,
      );

  Future<void> approveMany(Iterable<String> listingIds) async {
    for (final id in listingIds) {
      await _dataSource.updateStatus(
        listingId: id,
        status: ListingStatus.approved,
      );
    }
    _ref.invalidate(adminListingsProvider);
  }

  Future<void> rejectMany(Iterable<String> listingIds) async {
    for (final id in listingIds) {
      await _dataSource.updateStatus(
        listingId: id,
        status: ListingStatus.rejected,
      );
    }
    _ref.invalidate(adminListingsProvider);
  }

  Future<void> delete(String listingId) async {
    await _dataSource.deleteListing(listingId);
    _ref.invalidate(adminListingsProvider);
  }

  Future<void> _updateStatus(String listingId, ListingStatus status) async {
    await _dataSource.updateStatus(listingId: listingId, status: status);
    _ref.invalidate(adminListingsProvider);
  }
}

final adminListingsControllerProvider = Provider<AdminListingsController>((ref) {
  return AdminListingsController(
    ref.watch(adminListingsDataSourceProvider),
    ref,
  );
});

List<ListingModel> sortListingsDefault(List<ListingModel> listings) {
  int priority(ListingStatus status) => switch (status) {
        ListingStatus.pendingReview => 0,
        ListingStatus.draft => 1,
        ListingStatus.approved => 2,
        ListingStatus.rejected => 3,
      };

  final sorted = [...listings];
  sorted.sort((a, b) {
    final statusCompare = priority(a.status).compareTo(priority(b.status));
    if (statusCompare != 0) return statusCompare;
    return b.createdAt.compareTo(a.createdAt);
  });
  return sorted;
}

List<ListingModel> filterListingsByStatus(
  List<ListingModel> listings,
  ListingStatus? status,
) {
  if (status == null) return listings;
  return listings.where((listing) => listing.status == status).toList();
}
