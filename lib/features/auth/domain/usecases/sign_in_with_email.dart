import 'package:bazaar/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmail {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  AuthRepository get repository => _repository;
}
