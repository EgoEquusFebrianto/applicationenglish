import 'package:firebase_auth/firebase_auth.dart';
import 'package:applicationenglish/fitur/sqflite/user.dart';
import 'package:applicationenglish/fitur/sqflite/database_helper.dart';
import 'package:http/http.dart' as http;

class MyauthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = DatabaseHelper();

  // Fungsi sign up menggunakan Firebase Authentication
  Future<String?> signUp(String email, String pass) async {
    try {
      UserCredential authRes = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = authRes.user;
      
      if (user != null) {
        db.saveUserOffline(UserDefine(
          uid: user.uid,
          username: user.displayName ?? "Nama Pengguna",
          email: user.email!,
          password: pass,
        ));
      }
      return user?.uid;
    } on FirebaseAuthException catch (e) {
      print("Sign up error: ${e.message}");
      return null;
    } catch (e) {
      print("Koneksi Firebase gagal: $e");
      return null;
    }
  }

  // Fungsi sign in menggunakan Firebase Authentication
  Future<String?> signIn(String email, String pass) async {
    try {
      UserCredential authRes = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = authRes.user;
      if (user != null) {
        // Simpan data pengguna jika login berhasil
        await db.saveUserOffline(UserDefine(
          uid: user.uid,
          username: user.displayName ?? "Nama Pengguna",
          email: user.email!,
          password: pass,
        ));
      }
      return user?.uid;
    } on FirebaseAuthException catch (e) {
      print("Login gagal: ${e.message}");
    }
    return null; // Jika login gagal, kembalikan null
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Fungsi untuk mengecek koneksi Firebase
  Future<bool> checkFirebaseConnection() async {
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/scanning.json'));

      // Jika status code 200 (OK), berarti terhubung dengan Firebase
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Tidak dapat terhubung ke Firebase: $e");
      return false;
    }
  }

  // Fungsi untuk mendapatkan kredensial pengguna yang sudah terhubung di Firebase
  Future<User?> getUserCredencial() async{
    User? user = _firebaseAuth.currentUser;
    return user;
  }

  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    final dbName = await db.database;
    final List<Map<String, dynamic>> result = await dbName.query(
      'users',
      columns: ['username', 'email'],
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if(result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Fungsi login offline melalui SQLite
  Future<String?> signInOffline(String email, String password) async {
    try {
      print("INPUT TELAH MASUK");
      UserDefine? user = await db.validateUserOffline(email, password);
      if (user != null) {
        print("AUTENTIKASI TELAH DITERIMA");
        return user.uid; // Return UID jika user ditemukan
      }
      return null;
    } catch (e) {
      print("AUTHENTIKASI TIDAK DAPAT DITEMUKAN");
      print("Login offline gagal: $e");
      return null;
    }
  }

  Future<void> deleteUser(String email, String password) async {
    try {
      await signIn(email, password);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
        print('User berhasil dihapus dari Firebase: $email');
      } else {
        print('Tidak ada user yang login untuk dihapus.');
      }
    } catch (e) {
      print('Gagal menghapus user dari Firebase: $e');
      throw e;
    }
  }
}
