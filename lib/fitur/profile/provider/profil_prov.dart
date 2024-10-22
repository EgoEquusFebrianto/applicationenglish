import 'package:flutter/material.dart';

class CekProfil {
  String picture;
  String nama;
  String email;
  String noTelp;
  String alamat;

  CekProfil(
      {required this.picture,
      required this.nama,
      required this.email,
      required this.noTelp,
      required this.alamat});
}

class ProfilProv extends ChangeNotifier {
  final List<CekProfil> _profil = [];

  List<CekProfil> get profil => _profil;

  ProfilProv() {
    _profil.add(CekProfil(
      picture: "",
      nama: "Admin",
      email: "admin@main.com",
      noTelp: "",
      alamat: "",
    ));
  }
  void updateProfil(CekProfil profil) {
    _profil.clear();
    _profil.add(profil);
    notifyListeners(); 
  }
}
