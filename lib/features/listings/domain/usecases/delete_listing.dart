import 'package:bazaar/features/listings/domain/repositories/listing_repository.dart';

class DeleteListing {
  const DeleteListing(this._repository);

  final ListingRepository _repository;

  ListingRepository get repository => _repository;
}
