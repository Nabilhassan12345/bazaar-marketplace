import 'package:bazaar/features/auth/domain/repositories/auth_repository.dart';

class SignOut {
  const SignOut(this._repository);

  final AuthRepository _repository;

  AuthRepository get repository => _repository;
}
