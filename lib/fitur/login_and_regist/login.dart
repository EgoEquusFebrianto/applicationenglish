import 'package:applicationenglish/Home.dart';
import 'package:applicationenglish/fitur/login_and_regist/HomeHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _auth.signIn("asd@gmail.com", "zzzzzz").then((_uid) {
      _auth.getUserInfo(_uid!).then((_dataUser) {
        Provider.of<UserProvider>(context, listen: false).setUserData(_dataUser!, _uid);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(dataUser: _dataUser, uid: _uid)));
      });
    });
  }

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
          return null;
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
          return null;
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
        Provider.of<UserProvider>(context, listen: false).setUserData(res!, uidUser!);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(dataUser: res, uid: uidUser)));
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
