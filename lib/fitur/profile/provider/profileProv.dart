import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profil_User.dart';

class FirestoreInterface extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirestoreModel? _data;
  FirestoreModel? get data => _data;
  bool check = false;
  String uid = "";

  Future<void> setUid(String _uid) async {
    uid = _uid;
    notifyListeners();
  }

  Future<void> fetchDocument() async {
    try {
      var collection = await db.collection('ListofUserApp').doc(uid).get();
      if (collection.exists) {
        _data = FirestoreModel.fromFirestore(collection);
        check = true;
      }
      notifyListeners();
    } catch (e) {
      print('Error saat mengambil dokumen: $e');
    }
  }

  Future<void> catchUser() async {
    try {
      await fetchDocument();
      if (!check) {
        insertDocument();
        fetchDocument();
      }
    } catch (e) {
      print("error terjadi saat Memproses data ${e}");
    }
  }

  Future<void> updateDocument(Map<String, dynamic> updateData) async {
    try {
      _data = FirestoreModel(
          name: updateData['NewName'],
          telp: updateData['NewNumberPhone'],
          statistic: data!.statistic,
          exp: data!.exp,
          reward: data!.reward
          );
      await db
          .collection("ListofUserApp")
          .doc(uid)
          .update({"name": _data?.name, "telp": _data?.telp});
      notifyListeners(); // Memanggil notifyListeners untuk memperbarui UI
    } catch (e) {
      print('Error saat mengupdate dokumen: $e');
    }
  }

  Future<void> updateReward(Map<String, dynamic> updateData) async {
    try {
      _data = FirestoreModel(
        name: data!.name, 
        telp: data!.telp, 
        statistic: data!.exp, 
        exp: data!.exp, 
        reward: updateData
      );

      await db
        .collection("ListofUserApp")
        .doc(uid)
        .update({"rewad": _data?.reward});
      notifyListeners();
    } catch(err) {
      print('Error saat mengupdate dokumen: $err');
    }
  }

  Future<void> insertDocument() async {
    try {
      FirestoreModel insertData =
          FirestoreModel(
            name: "Nama Pengguna", 
            telp: "", 
            statistic: {
              "access_level": 1,
              "PerfectStreak": {"fiture_1": 0, "fiture_2": 0},
              "playing": {"fiture_1": 0, "fiture_2": 0}, 
              "point_f1": {"beginner": 0, "intermediate": 0, "advance": 0},
              "point_f2": 0 
            }, 
            exp: {
              "PlayerLevel": 0,
              "experience": 0
            },
            reward: {
              "admob": [],
              "general": []
            }
          );
      // await db.collection("ListofUserApp").add(insertData.toMap());
      await db.collection("ListofUserApp").doc(uid).set(insertData.toMap());
    } catch (e) {
      print('Error saat menambah dokumen: $e');
    }
  }
}
