import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'fitur/providers/translation_provider.dart';

class HomeProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  void translateText(BuildContext context) {
    final translationProvider = Provider.of<TranslationProvider>(context, listen: false);
    translationProvider.translateText(_controller.text);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
