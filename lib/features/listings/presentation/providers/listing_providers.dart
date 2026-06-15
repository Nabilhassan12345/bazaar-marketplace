import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/auth/domain/entities/user_entity.dart';
import 'package:bazaar/features/listings/data/datasources/listing_remote_datasource.dart';
import 'package:bazaar/features/listings/data/datasources/listing_storage_datasource.dart';
import 'package:bazaar/features/listings/data/repositories/listing_repository_impl.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/domain/repositories/listing_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listingRemoteDataSourceProvider = Provider<ListingRemoteDataSource>((ref) {
  return ListingRemoteDataSource();
});

final listingStorageDataSourceProvider = Provider<ListingStorageDataSource>((ref) {
  return ListingStorageDataSource();
});

final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  return ListingRepositoryImpl(
    ref.watch(listingRemoteDataSourceProvider),
    ref.watch(listingStorageDataSourceProvider),
  );
});

final myListingsProvider =
    FutureProvider.autoDispose<List<ListingEntity>>((ref) async {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  if (user == null) return [];
  return ref.watch(listingRepositoryProvider).getMyListings(user.id);
});

final listingDetailProvider =
    FutureProvider.autoDispose.family<ListingEntity?, String>((ref, listingId) async {
  return ref.watch(listingRepositoryProvider).getListingById(listingId);
});

final userProfileProvider =
    FutureProvider.autoDispose.family<UserEntity?, String>((ref, userId) async {
  return ref.watch(authRepositoryProvider).getUserById(userId);
});
