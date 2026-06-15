import 'package:bazaar/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  AuthRepository get repository => _repository;
}
