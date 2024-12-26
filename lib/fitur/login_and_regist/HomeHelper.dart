import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _dataUser;
  String? _uid;

  Map<String, dynamic>? get dataUser => _dataUser;
  String? get uid => _uid;

  void setUserData(Map<String, dynamic> dataUser, String uid) {
    _dataUser = dataUser;
    _uid = uid;
    notifyListeners();
  }
}
