import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_provider.dart';
import 'fitur/login_and_regist/login.dart';
import 'fitur/profile/provider/profil_prov.dart';
import 'fitur/profile/provider/switchProvider.dart';
import 'fitur/Challanges/TranslateGames/game_provider.dart';
import 'fitur/Challanges/myDictionary/_Provider.dart';
import 'fitur/Challanges/Sentences/HandlerButton_prov.dart';
import 'fitur/Challanges/Sentences/_services.dart';
import 'fitur/providers/translation_provider.dart';

// import 'fitur/Challanges/Sentences/HandlerButton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLoggedIn = await _getLoginStatus();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp(
      isLoggedIn: isLoggedIn,
    ));
  });
}

Future<bool> _getLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfilProv()),
        ChangeNotifierProvider(create: (context) => SwitchModeProvider()),
        ChangeNotifierProvider(create: (context) => WordProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => TranslationProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => HandlerButtonProvider()),
        ChangeNotifierProvider(create: (context) => ClickedButtonListProvider()),
      ],
      child: Consumer<SwitchModeProvider>(builder: (context, value, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: value.themeData,
          title: 'Learning_App',
          home: LoginScreen(),
          // home: HandlerButton(),
        );
      }),
    );
  }
}
