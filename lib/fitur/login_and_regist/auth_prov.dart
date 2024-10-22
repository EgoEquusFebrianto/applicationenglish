import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _email = '';
  String _username = '';
  String _password = '';
  bool _isLoggedIn = false;

  String get email => _email;
  String get username => _username;
  String get password => _password;
  bool get isLoggedIn => _isLoggedIn;

  UserProfile _profil = UserProfile(nama: '', email: '', username: '', alamat: '', picture: '');
  UserProfile get profil => _profil;

  Future<void> register(String username, String email, String password) async {
    await saveRegisterInfo(username, email, password);
    _profil = UserProfile(
      nama: getNameFromUsername(username),
      username: username,
      email: email,
      alamat: '',
      picture: '',
    );
    notifyListeners();
  }

  Future<void> loadRegisterInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('registerUsername') ?? '';
    _email = prefs.getString('registerEmail') ?? '';
    _password = prefs.getString('registerPassword') ?? '';
    notifyListeners();
  }

  Future<void> saveRegisterInfo(String username, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('registerUsername', username);
    await prefs.setString('registerEmail', email);
    await prefs.setString('registerPassword', password);
    _username = username;
    _email = email;
    _password = password;
  }

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  Future<void> loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<bool> registerUser(String username, String email, String password) async {
    if (await isUsernameTaken(username)) {
      return false;
    }
    try {
      await saveRegisterInfo(username, email, password);
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? existingUsername = prefs.getString('registerUsername');
    return existingUsername == username;
  }

  bool validateCredentials(String username, String password) {
    print('Stored username: $_username, Stored password: $_password');
    print('Entered username: $username, Entered password: $password');
    return _username == username && _password == password;
  }

  String getNameFromEmail(String email) {
    return email.split('@')[0];
  }

  String getNameFromUsername(String username) {
    return username;
  }

  void updateProfil(String nama, String username, String email, String alamat, String picture) {
    _profil = UserProfile(nama: nama, username: username, email: email, alamat: alamat, picture: picture);
    notifyListeners();
  }
}

class UserProfile {
  String nama;
  String username;
  String email;
  String alamat;
  String picture;

  UserProfile({
    required this.nama,
    required this.username,
    required this.email,
    required this.alamat,
    required this.picture,
  });
}
