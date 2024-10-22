import 'package:flutter/material.dart';

class HandlerButtonProvider with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> navigateToPage(BuildContext context, Widget page) async {
    setLoading(true);

    await Future.delayed(const Duration(milliseconds: 500));
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    setLoading(false);
  }
}
