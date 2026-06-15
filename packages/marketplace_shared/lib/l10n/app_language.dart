/// Supported app languages (ISO 639-1).
enum AppLanguage {
  fr('fr', 'Français', 'French'),
  en('en', 'English', 'English'),
  ar('ar', 'العربية', 'Arabic');

  const AppLanguage(this.code, this.nativeName, this.englishName);

  final String code;
  final String nativeName;
  final String englishName;

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.fr,
    );
  }

  static const defaultLanguage = AppLanguage.fr;

  static const supportedCodes = ['fr', 'en', 'ar'];
}
