/// Generates lowercase search tokens from listing title and description.
List<String> generateSearchTokens({
  required String title,
  required String description,
}) {
  final text = '${title.toLowerCase()} ${description.toLowerCase()}';
  return text
      .split(RegExp(r'[^a-z0-9]+'))
      .where((word) => word.length >= 2)
      .toSet()
      .toList();
}

/// Extracts searchable tokens from a user query.
List<String> extractSearchQueryTokens(String query) {
  return query
      .toLowerCase()
      .split(RegExp(r'[^a-z0-9]+'))
      .where((word) => word.length >= 2)
      .toList();
}

/// Primary token used for Firestore `arrayContains` queries.
String? primarySearchToken(String query) {
  final tokens = extractSearchQueryTokens(query);
  return tokens.isEmpty ? null : tokens.first;
}

bool listingMatchesQueryTokens({
  required String title,
  required String description,
  required List<String> queryTokens,
}) {
  if (queryTokens.isEmpty) return true;
  final haystack = '${title.toLowerCase()} ${description.toLowerCase()}';
  return queryTokens.every(haystack.contains);
}
