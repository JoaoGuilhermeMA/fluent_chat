// /lib/core/utils/translation_helper.dart
import 'package:translator/translator.dart'; // Supondo que você esteja usando a biblioteca 'translator'

class TranslationHelper {
  static final GoogleTranslator _translator = GoogleTranslator();

  static Future<String> translateText(String text, {String to = 'pt'}) async {
    try {
      var translation = await _translator.translate(text, to: to);
      return translation.text;
    } catch (e) {
      throw Exception('Failed to translate text: $e');
    }
  }
}
