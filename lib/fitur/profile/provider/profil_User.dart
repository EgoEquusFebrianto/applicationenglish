import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreModel {
  final String name;
  final String telp;
  final Map<String, dynamic> statistic;
  final Map<String, dynamic> exp;

  FirestoreModel({
    required this.name,
    required this.telp,
    required this.statistic,
    required this.exp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'telp': telp,
      'statistic': statistic,
      'exp': exp,
    };
  }
  
  factory FirestoreModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return FirestoreModel(
      name: doc.data()?['name'] ?? '',
      telp: doc.data()?['telp'] ?? '',
      statistic: doc.data()?['statistic'] ?? {},
      exp: doc.data()?['exp'] ?? {},
    );
  }
}
