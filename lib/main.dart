import 'package:applicationenglish/MainProviderSystem.dart';
import 'package:applicationenglish/fitur/login_and_regist/HomeHelper.dart';
import 'package:applicationenglish/fitur/profile/provider/profileProv.dart';
import 'package:applicationenglish/fitur/treasure/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'package:awesome_notifications/awesome_notifications.dart';

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';


Future<void> _initializeNotifications() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  AwesomeNotifications().initialize(
    "resource://drawable/learning_app",
    [
      NotificationChannel(
        channelKey: "schedule_channel",
        channelName: "Schedule Notifications",
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: "Notifikasi Terjadwal untuk Pengingat",
      ),
    ],
  );
}

Future<void> ensureDailyNotificationScheduled() async {
  List<NotificationModel> scheduledNotifications = await AwesomeNotifications().listScheduledNotifications();

  if (scheduledNotifications.isEmpty) {
    print('Belum ada notifikasi yang dijadwalkan.');
    scheduleDailyNotification();
  } else {
    print('Notifikasi sudah dijadwalkan. $scheduledNotifications');
  }
}

void scheduleDailyNotification() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  
  DateTime now = DateTime.now();
  DateTime notificationTime = DateTime(
    now.year,
    now.month,
    now.day,
    20,
    36,
  );

  await AwesomeNotifications().cancelAllSchedules();

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'schedule_channel',
      title: 'Ayo Latihan Bahasa Inggris!',
      body: 'Jangan lupa untuk melatih keterampilan bahasa Inggris Anda hari ini.',
      notificationLayout: NotificationLayout.Default,
    ),
    schedule: NotificationCalendar(
      year: notificationTime.year,
      month: notificationTime.month,
      day: notificationTime.day,
      hour: notificationTime.hour,
      minute: notificationTime.minute,
      second: 0,
      preciseAlarm: true,
      allowWhileIdle: true,
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      repeats: true,
    ),
  );
  scheduleNotificationCancellation();
}

void scheduleNotificationCancellation() {
  DateTime now = DateTime.now();
  DateTime midnight = DateTime( 
    now.year,
    now.month,
    now.day + 1,
    0,
    0,
    0,
  ); // Hitung durasi hingga pukul 00:00 (midnight)

  Duration durationUntilMidnight = midnight.difference(now);

  Future.delayed(durationUntilMidnight, () {
    AwesomeNotifications().cancel(1);
    print('Notifikasi dibatalkan karena sudah lewat pukul 00:00.');
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  bool isLoggedIn = await _getLoginStatus();
  await AwesomeNotifications().resetGlobalBadge();
  await AwesomeNotifications().setGlobalBadgeCounter(0);
  await _initializeNotifications();
  ensureDailyNotificationScheduled();
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

// Future<void> deleteDatabaseFile() async {
//   final dbPath = await getDatabasesPath();
//   final path = join(dbPath, 'user_database.db');
//   await deleteDatabase(path);
// }

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
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
