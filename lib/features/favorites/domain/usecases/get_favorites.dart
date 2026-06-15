import 'package:bazaar/features/favorites/domain/repositories/favorite_repository.dart';

class GetFavorites {
  const GetFavorites(this._repository);

  final FavoriteRepository _repository;

  FavoriteRepository get repository => _repository;
}
