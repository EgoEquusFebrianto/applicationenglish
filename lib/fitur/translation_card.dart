import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class TranslationCard extends StatelessWidget {
  final TextEditingController controller;
  final String sourceLanguage;
  final String targetLanguage;
  final String translatedText;
  final Function(String?) onSourceLanguageChanged;
  final Function(String?) onTargetLanguageChanged;
  final Function() onTranslatePressed;

  const TranslationCard({
    required this.controller,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.translatedText,
    required this.onSourceLanguageChanged,
    required this.onTargetLanguageChanged,
    required this.onTranslatePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
      elevation: 20,
      shadowColor: Colors.black54,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'TC_textfield'.i18n(),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDropdownButton(sourceLanguage, onSourceLanguageChanged),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, color: Colors.white),
                    onPressed: () {
                      _swapLanguages();
                    },
                  ),
                  _buildDropdownButton(targetLanguage, onTargetLanguageChanged),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onTranslatePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('TC_elevatedbuttonlabel'.i18n()),
              ),
              const SizedBox(height: 50),
              Text(
                translatedText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _swapLanguages() {
    final tempLanguage = sourceLanguage;
    onSourceLanguageChanged(targetLanguage);
    onTargetLanguageChanged(tempLanguage);
  }

  Widget _buildDropdownButton(
      String value, void Function(String?)? onChanged) {
    return DropdownButton<String>(
      value: value,
      dropdownColor: Colors.blueAccent,
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text('English', style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: 'id',
          child: Text('Indonesian', style: TextStyle(color: Colors.white)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
