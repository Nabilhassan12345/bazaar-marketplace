import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryState {
  const CategoryState();
}

class CategoryCubit extends Notifier<CategoryState> {
  @override
  CategoryState build() => const CategoryState();
}

final categoryCubitProvider =
    NotifierProvider<CategoryCubit, CategoryState>(CategoryCubit.new);
