import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/l10n/app_language.dart';
import 'package:marketplace_shared/l10n/bazaar_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _adminLocalePrefsKey = 'bazaar_admin_locale';

final adminLocaleProvider =
    StateNotifierProvider<AdminLocaleController, AppLanguage>((ref) {
  throw UnimplementedError('adminLocaleProvider must be overridden in main.dart');
});

final adminStringsProvider = Provider<BazaarStrings>((ref) {
  final language = ref.watch(adminLocaleProvider);
  return BazaarStrings(language);
});

class AdminLocaleController extends StateNotifier<AppLanguage> {
  AdminLocaleController(this._prefs)
      : super(AppLanguage.fromCode(_prefs.getString(_adminLocalePrefsKey)));

  final SharedPreferences _prefs;

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    await _prefs.setString(_adminLocalePrefsKey, language.code);
  }
}

Override adminLocaleOverride(SharedPreferences prefs) {
  return adminLocaleProvider.overrideWith(
    (ref) => AdminLocaleController(prefs),
  );
}

extension AdminStringsContext on WidgetRef {
  BazaarStrings get str => watch(adminStringsProvider);
}
