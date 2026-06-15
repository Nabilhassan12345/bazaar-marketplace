/// Trilingual place name (English, French, Arabic).
class LocalizedName {
  const LocalizedName({
    required this.en,
    required this.fr,
    required this.ar,
  });

  final String en;
  final String fr;
  final String ar;

  String forLanguage(String languageCode) => switch (languageCode) {
        'fr' => fr,
        'ar' => ar,
        _ => en,
      };
}
