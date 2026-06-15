import 'package:bazaar/features/search/presentation/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/l10n/app_language.dart';
import 'package:marketplace_shared/l10n/bazaar_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localePrefsKey = 'bazaar_locale';

final localeProvider =
    StateNotifierProvider<LocaleController, AppLanguage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleController(prefs);
});

final bazaarStringsProvider = Provider<BazaarStrings>((ref) {
  final language = ref.watch(localeProvider);
  return BazaarStrings(language);
});

class LocaleController extends StateNotifier<AppLanguage> {
  LocaleController(this._prefs)
      : super(
          AppLanguage.fromCode(_prefs.getString(_localePrefsKey)),
        );

  final SharedPreferences _prefs;

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    await _prefs.setString(_localePrefsKey, language.code);
  }
}

extension BazaarStringsContext on WidgetRef {
  BazaarStrings get str => watch(bazaarStringsProvider);
}

extension BazaarStringsRead on Ref {
  BazaarStrings get str => read(bazaarStringsProvider);
}
