import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingListState {
  const ListingListState();
}

class ListingListCubit extends Notifier<ListingListState> {
  @override
  ListingListState build() => const ListingListState();
}

final listingListCubitProvider =
    NotifierProvider<ListingListCubit, ListingListState>(ListingListCubit.new);
