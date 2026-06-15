import 'package:bazaar/features/categories/domain/repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final CategoryRepository _repository;

  CategoryRepository get repository => _repository;
}
