import 'package:flutter/material.dart';

class ListingReviewDetailPage extends StatelessWidget {
  const ListingReviewDetailPage({required this.listingId, super.key});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Listing')),
      body: Center(child: Text('Listing: $listingId')),
    );
  }
}
