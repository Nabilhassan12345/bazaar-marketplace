enum ReportReason {
  spam,
  fraud,
  inappropriate,
  wrongCategory,
  other;

  String get value => switch (this) {
        ReportReason.spam => 'spam',
        ReportReason.fraud => 'fraud',
        ReportReason.inappropriate => 'inappropriate',
        ReportReason.wrongCategory => 'wrong_category',
        ReportReason.other => 'other',
      };

  String get label => switch (this) {
        ReportReason.spam => 'Spam',
        ReportReason.fraud => 'Fraud',
        ReportReason.inappropriate => 'Inappropriate',
        ReportReason.wrongCategory => 'Wrong category',
        ReportReason.other => 'Other',
      };

  static ReportReason fromValue(String value) => switch (value) {
        'spam' => ReportReason.spam,
        'fraud' => ReportReason.fraud,
        'inappropriate' => ReportReason.inappropriate,
        'wrong_category' => ReportReason.wrongCategory,
        'other' => ReportReason.other,
        _ => ReportReason.other,
      };
}
