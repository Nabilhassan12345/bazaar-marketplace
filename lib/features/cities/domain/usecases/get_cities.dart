import 'package:bazaar/features/cities/domain/repositories/city_repository.dart';

class GetCities {
  const GetCities(this._repository);

  final CityRepository _repository;

  CityRepository get repository => _repository;
}
