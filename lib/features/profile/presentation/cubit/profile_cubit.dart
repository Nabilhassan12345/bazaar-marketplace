import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  const ProfileState();
}

class ProfileCubit extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();
}

final profileCubitProvider =
    NotifierProvider<ProfileCubit, ProfileState>(ProfileCubit.new);
