enum ListingStatus {
  draft,
  pendingReview,
  approved,
  rejected;

  String get value => switch (this) {
        ListingStatus.draft => 'draft',
        ListingStatus.pendingReview => 'pending_review',
        ListingStatus.approved => 'approved',
        ListingStatus.rejected => 'rejected',
      };

  static ListingStatus fromValue(String value) => switch (value) {
        'draft' => ListingStatus.draft,
        'pending_review' => ListingStatus.pendingReview,
        'approved' => ListingStatus.approved,
        'rejected' => ListingStatus.rejected,
        _ => ListingStatus.draft,
      };
}
