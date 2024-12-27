import 'package:applicationenglish/MainProviderSystem.dart';
import 'package:applicationenglish/fitur/login_and_regist/HomeHelper.dart';
import 'package:applicationenglish/fitur/profile/provider/profileProv.dart';
import 'package:applicationenglish/fitur/treasure/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_provider.dart';
import 'fitur/login_and_regist/login.dart';
import 'fitur/profile/provider/switchProvider.dart';
import 'fitur/Challanges/TranslateGames/game_provider.dart';
import 'fitur/Challanges/myDictionary/_Provider.dart';
import 'fitur/Challanges/Sentences/HandlerButton_prov.dart';
import 'fitur/Challanges/Sentences/_services.dart';
import 'fitur/providers/translation_provider.dart';

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
    LocalJsonLocalization.delegate.directories = ["lib/i18n"];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FirestoreInterface()),
        ChangeNotifierProvider(create: (context) => SwitchModeProvider()),
        ChangeNotifierProvider(create: (context) => WordProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => TranslationProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => HandlerButtonProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ClickedButtonListProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider('assets/sample_video.mp4')),
      ],
      child: Consumer<SwitchModeProvider>(builder: (context, value, _) {
        // var localeProvider = Provider.of<LocaleProvider>(context);
        return Consumer<LocaleProvider>(builder: (context, localeProvider, _) {
          return MaterialApp(
            supportedLocales: [
              Locale("id", "ID"), 
              Locale("en", "US")
            ],
            locale: localeProvider.locale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              LocalJsonLocalization.delegate
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (supportedLocales.contains(locale)) {
                return locale;
              }
              return Locale("en", "US");
            },
            debugShowCheckedModeBanner: false,
            title: 'Learning_App',
            home: LoginScreen(),
          );
        });
      }),
    );
  }
}
