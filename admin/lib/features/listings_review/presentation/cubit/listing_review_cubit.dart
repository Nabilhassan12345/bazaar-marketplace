import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingReviewState {
  const ListingReviewState();
}

class ListingReviewCubit extends Notifier<ListingReviewState> {
  @override
  ListingReviewState build() => const ListingReviewState();
}

final listingReviewCubitProvider =
    NotifierProvider<ListingReviewCubit, ListingReviewState>(ListingReviewCubit.new);
