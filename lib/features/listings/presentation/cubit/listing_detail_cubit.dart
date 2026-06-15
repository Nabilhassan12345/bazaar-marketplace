import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingDetailState {
  const ListingDetailState();
}

class ListingDetailCubit extends Notifier<ListingDetailState> {
  @override
  ListingDetailState build() => const ListingDetailState();
}

final listingDetailCubitProvider =
    NotifierProvider<ListingDetailCubit, ListingDetailState>(ListingDetailCubit.new);
