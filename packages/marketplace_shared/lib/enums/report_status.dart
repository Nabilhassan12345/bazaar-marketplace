enum ReportStatus {
  open,
  pending,
  reviewed,
  resolved,
  dismissed;

  String get value => name;

  static ReportStatus fromValue(String value) => ReportStatus.values.firstWhere(
        (status) => status.name == value,
        orElse: () => ReportStatus.pending,
      );
}
