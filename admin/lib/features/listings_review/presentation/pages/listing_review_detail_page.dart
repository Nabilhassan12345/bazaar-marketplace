import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingReviewDetailPage extends ConsumerWidget {
  const ListingReviewDetailPage({required this.listingId, super.key});

  final String listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    return Scaffold(
      appBar: AppBar(title: Text(s.reviewListing)),
      body: Center(child: Text(s.listingReviewId(listingId))),
    );
  }
}
