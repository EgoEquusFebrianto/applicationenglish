import 'package:applicationenglish/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'auth_firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final MyauthFirebase _auth = MyauthFirebase();
  bool _onLoginSession = false;
  bool _onSignUpSession = false;
  String? uidUser;

  // @override
  // void initState() {
  //   super.initState();
  //   _auth.checkFirebaseConnection().then((isConnected) {
  //     print('the result is $isConnected');
  //   });
  //   _checkLoginSession();
  // }

  // Fungsi untuk memeriksa waktu login terakhir
  // Future<void> _checkLoginSession() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final lastLogin = prefs.getInt('last_login');
  //   final currentTime = DateTime.now().millisecondsSinceEpoch;

  //   if (lastLogin != null) {
  //     final differenceInDays =
  //         (currentTime - lastLogin) / (1000 * 60 * 60 * 24);

  //     if (differenceInDays > 2) {
  //       // Jika lebih dari 2 hari, arahkan ke halaman login
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //     } else {
  //       // Jika masih dalam masa login otomatis, cek koneksi dan lanjutkan ke halaman CheckDatabaseScreen
  //       _auth.checkFirebaseConnection().then((isConnected) {
  //         if (isConnected) {
  //           _auth.getUserCredencial().then((user) {
  //             if (user != null) {
  //               Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => CheckDatabaseScreen()));
  //             } else {
  //               print("Tidak ditemukan kredensial di Firebase");
  //             }
  //           });
  //         } else {
  //           _auth.signInOffline("email", "password").then((userId) {
  //             if (userId != null) {
  //               Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => CheckDatabaseScreen()));
  //             } else {
  //               print("Tidak ditemukan kredensial secara offline");
  //             }
  //           });
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _onLogin,
      onRecoverPassword: _onRecoverPassword,
      onSignup: _onSignUp,
      // ignore: body_might_complete_normally_nullable
      passwordValidator: (value) {
        if (value != null && value.length < 6) {
          return "Password minimal 6 karakter";
        }
      },
      loginProviders: [
        LoginProvider(
            callback: _onGoogleSignIn,
            icon: FontAwesomeIcons.google,
            label: "Google"),
        LoginProvider(
            callback: _onFacebookleSignIn,
            icon: FontAwesomeIcons.facebook,
            label: "Facebook"),
      ],
      onSubmitAnimationCompleted: _onSubmitAnimationCompleted,
    );
  }

  Future<String?>? _onLogin(LoginData data) async {
    bool isConnected = await _auth.checkFirebaseConnection();

    if (isConnected) {
      return _auth.signIn(data.name, data.password).then((value) {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sign in Berhasil Firebase")));
          _onLoginSession = true;
          uidUser = value;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Sign in Gagal Firebase")));
        }
      });
    } else {
      return _auth.signInOffline(data.name, data.password).then((value) {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sign in Berhasil SQFLite")));
          _onLoginSession = true;
          uidUser = value;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Sign in Gagal SQFLite")));
        }
      });
    }
  }

  Future<String?>? _onSignUp(SignupData data) async {
    bool isConnected = await _auth.checkFirebaseConnection();

    if (isConnected) {
      return _auth.signUp(data.name!, data.password!).then((value) {
        if (value != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Sign Up Berhasil")));
          _onSignUpSession = true;
          uidUser = value;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Sign Up Gagal")));
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Tidak ada koneksi internet")));
      return null;
    }
  }

  void _onSubmitAnimationCompleted() async {
    if (_onLoginSession || _onSignUpSession) {
      await _auth.getUserInfo(uidUser!).then((res) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(dataUser: res)));
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<String?>? _onRecoverPassword(String email) async {
    return null;
  }

  Future<String?>? _onGoogleSignIn() async {
    return null;
  }

  Future<String?>? _onFacebookleSignIn() async {
    return null;
  }
}
