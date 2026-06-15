import 'package:bazaar/features/auth/domain/entities/user_entity.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

sealed class AuthStatus {
  const AuthStatus();
}

class AuthInitial extends AuthStatus {
  const AuthInitial();
}

class AuthLoading extends AuthStatus {
  const AuthLoading();
}

class AuthAuthenticated extends AuthStatus {
  const AuthAuthenticated(this.user);
  final UserEntity user;
}

class AuthUnauthenticated extends AuthStatus {
  const AuthUnauthenticated();
}

class AuthError extends AuthStatus {
  const AuthError(this.message);
  final String message;
}
