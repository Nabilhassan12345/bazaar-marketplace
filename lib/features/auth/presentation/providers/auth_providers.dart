import 'package:bazaar/core/firebase/analytics_service.dart';
import 'package:bazaar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bazaar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bazaar/features/auth/domain/entities/user_entity.dart';
import 'package:bazaar/features/auth/domain/repositories/auth_repository.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref) async* {
  final repository = ref.watch(authRepositoryProvider);

  // Emit immediately so the app doesn't hang on splash while waiting
  // for Firebase Auth's first stream event (common on web).
  try {
    yield await repository.getCurrentUser();
  } catch (_) {
    yield null;
  }

  yield* repository.authStateChanges();
});

final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  return ref.watch(authRepositoryProvider).getCurrentUser();
});

class AuthController extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => const AuthInitial();

  AuthRepository get _repository => ref.read(authRepositoryProvider);
  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      await _analytics.logEvent('login', parameters: {'method': 'email'});
      state = AuthAuthenticated(user);
    } on AuthException catch (error) {
      state = AuthError(error.message);
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      await _analytics.logEvent('sign_up', parameters: {'method': 'email'});
      state = AuthAuthenticated(user);
    } on AuthException catch (error) {
      state = AuthError(error.message);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      final user = await _repository.signInWithGoogle();
      await _analytics.logEvent('login', parameters: {'method': 'google'});
      state = AuthAuthenticated(user);
    } on AuthException catch (error) {
      state = AuthError(error.message);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    await _analytics.logEvent('logout');
    state = const AuthUnauthenticated();
  }

  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthStatus>(AuthController.new);
