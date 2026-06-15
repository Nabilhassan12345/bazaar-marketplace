import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState();
}

class AuthCubit extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();
}

final authCubitProvider =
    NotifierProvider<AuthCubit, AuthState>(AuthCubit.new);
