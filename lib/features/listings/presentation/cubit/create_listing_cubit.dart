import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateListingState {
  const CreateListingState();
}

class CreateListingCubit extends Notifier<CreateListingState> {
  @override
  CreateListingState build() => const CreateListingState();
}

final createListingCubitProvider =
    NotifierProvider<CreateListingCubit, CreateListingState>(CreateListingCubit.new);
