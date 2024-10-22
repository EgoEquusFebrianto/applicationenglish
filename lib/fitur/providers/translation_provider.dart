import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslationProvider extends ChangeNotifier {
  String translatedText = '';
  String sourceLanguage = 'en';
  String targetLanguage = 'id';

  Future<void> translateText(String text) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(
      text,
      from: sourceLanguage,
      to: targetLanguage,
    );
    translatedText = translation.text;
    notifyListeners();
  }

  void setSourceLanguage(String language) {
    sourceLanguage = language;
    notifyListeners();
  }

  void setTargetLanguage(String language) {
    targetLanguage = language;
    notifyListeners();
  }
}
