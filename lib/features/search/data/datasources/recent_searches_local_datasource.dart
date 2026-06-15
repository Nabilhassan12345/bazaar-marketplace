import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesLocalDataSource {
  RecentSearchesLocalDataSource(this._prefs);

  static const _storageKey = 'recent_searches';
  static const _maxItems = 10;

  final SharedPreferences _prefs;

  List<String> getRecentSearches() {
    return _prefs.getStringList(_storageKey) ?? [];
  }

  Future<void> addSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final current = getRecentSearches()
        .where((item) => item.toLowerCase() != trimmed.toLowerCase())
        .toList();

    current.insert(0, trimmed);
    final updated = current.take(_maxItems).toList();
    await _prefs.setStringList(_storageKey, updated);
  }

  Future<void> removeSearch(String query) async {
    final updated = getRecentSearches()
        .where((item) => item != query)
        .toList();
    await _prefs.setStringList(_storageKey, updated);
  }
}
