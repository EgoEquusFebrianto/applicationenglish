import 'package:flutter_test/flutter_test.dart';
import 'package:applicationenglish/fitur/login_and_regist/auth_firebase.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Inisialisasi Firebase
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('Integration Test', () {
    final MyauthFirebase auth = MyauthFirebase();

    // Kredensial pengujian
    const email_valid = 'EMAIL VALID';
    const email_invalid = 'EMAIL INVALID';
    const pass_valid = 'PASSWORD VALID';
    const pass_invalid = 'PASSWORD INVALID';

    // Test untuk login dengan kredensial valid
    test('SKENARIO LOGIN FIREBASE BERHASIL dengan VALID credentials', () async {
      try {
        String? uid = await auth.signIn(email_valid, pass_valid);
        print('Hasil login dengan valid credentials: UID = $uid');
        expect(uid, isNotNull, reason: 'Login berhasil, UID tidak boleh null');
      } catch (e) {
        print('Error pada login dengan valid credentials: $e');
        fail('Terjadi error pada login dengan valid credentials.');
      }
    });

    // Test untuk login dengan kredensial tidak valid
    test('SKENARIO LOGIN FIREBASE GAGAL dengan INVALID credentials', () async {
      try {
        String? uid = await auth.signIn(email_invalid, pass_invalid);
        print('Hasil login dengan invalid credentials: UID = $uid');
        expect(uid, isNull, reason: 'Login gagal, UID harus null');
      } catch (e) {
        print('Error pada login dengan invalid credentials: $e');
        fail('Terjadi error pada login dengan invalid credentials.');
      }
    });

    // Test untuk login offline dengan kredensial valid
    test('SKENARIO LOGIN SQFLITE BERHASIL dengan VALID credentials', () async {
      try {
        String? uid = await auth.signInOffline(email_valid, pass_valid);
        print('Hasil login offline dengan valid credentials: UID = $uid');
        expect(uid, isNotNull, reason: 'Login offline berhasil, UID tidak boleh null');
      } catch (e) {
        print('Error pada offline login dengan valid credentials: $e');
        fail('Terjadi error pada offline login dengan valid credentials.');
      }
    });

    // Test untuk login offline dengan kredensial tidak valid (opsional, bisa diaktifkan jika diperlukan)
    test('SKENARIO LOGIN SQFLITE GAGAL dengan INVALID credentials', () async {
      try {
        String? uid = await auth.signInOffline(email_invalid, pass_invalid);
        print('Hasil login offline dengan invalid credentials: UID = $uid');
        expect(uid, isNull, reason: 'Login offline gagal, UID harus null');
      } catch (e) {
        print('Error pada offline login dengan invalid credentials: $e');
        fail('Terjadi error pada offline login dengan invalid credentials.');
      }
    });
  });
}
