enum ReportSubjectType {
  listing,
  user;

  String get value => name;

  static ReportSubjectType fromValue(String value) => switch (value) {
        'listing' => ReportSubjectType.listing,
        'user' => ReportSubjectType.user,
        _ => ReportSubjectType.listing,
      };
}
