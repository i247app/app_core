abstract class KTTSHelper {
  static const String ENGLISH = "en-US";
  static const String VIETNAMESE = "vi-VN";

  /// System TTS
  static Future speak(String text, {String? language}) async {
    // FlutterTts flutterTts = FlutterTts();
    //
    // // Setup language
    // try {
    //   final List availableLanguages = await flutterTts.getLanguages;
    //   if (!availableLanguages.contains(language))
    //     language = ENGLISH; // Default to english if language isn't supported
    // } catch (e) {
    //   language = ENGLISH;
    // }
    // flutterTts.setLanguage(language ?? ENGLISH); // Always set language
    //
    // return flutterTts.speak(text);
  }
}
