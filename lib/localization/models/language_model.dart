class LanguageModel {
  String? imageUrl;
  String? languageName;
  String? languageCode;
  String? countryCode;
  // Language code expected by the backend's `lang` header, which can differ
  // from the standard [languageCode] used for the app's own localization files.
  String? apiLanguageCode;

  LanguageModel({this.imageUrl, this.languageName, this.countryCode, this.languageCode, String? apiLanguageCode})
      : apiLanguageCode = apiLanguageCode ?? languageCode;
}
