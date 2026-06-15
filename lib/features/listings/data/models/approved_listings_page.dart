import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ApprovedListingsPage {
  const ApprovedListingsPage({
    required this.listings,
    required this.lastDocument,
    required this.hasMore,
  });

  final List<ListingModel> listings;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool hasMore;
}
