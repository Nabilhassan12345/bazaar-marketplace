import 'package:bazaar/features/auth/domain/entities/user_entity.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProfileProvider = FutureProvider<UserEntity?>((ref) async {
  final authUser = ref.watch(authStateChangesProvider).valueOrNull;
  if (authUser == null) return null;
  return ref.read(authRepositoryProvider).getUserById(authUser.id);
});

String userInitials(String displayName) {
  final parts = displayName.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
