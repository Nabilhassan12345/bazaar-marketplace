import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteState {
  const FavoriteState();
}

class FavoriteCubit extends Notifier<FavoriteState> {
  @override
  FavoriteState build() => const FavoriteState();
}

final favoriteCubitProvider =
    NotifierProvider<FavoriteCubit, FavoriteState>(FavoriteCubit.new);
