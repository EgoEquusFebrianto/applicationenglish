import 'package:applicationenglish/Home.dart';
import 'package:applicationenglish/fitur/login_and_regist/HomeHelper.dart';
import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:applicationenglish/MainProviderSystem.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class LenguageSet extends StatelessWidget {
  const LenguageSet({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    var localeProvider = Provider.of<LocaleProvider>(context);
    var userProvider = Provider.of<UserProvider>(context); 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.iconTheme,
        title: Text(
          'setLanguage'.i18n(),
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'setLanguage_info'.i18n(),
              style: TextStyle(color: theme.primaryColor),
            ),
            const SizedBox(height: 20),
            LanguageSelector(
              currentLocale: localeProvider.locale,
              onLocaleChange: (Locale newLocale) async {
                localeProvider.setLocale(newLocale);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                await Future.delayed(const Duration(seconds: 1));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home(
                    dataUser: userProvider.dataUser,
                    uid: userProvider.uid,
                  )),
                  (Route<dynamic> route) => false,
                );
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const LanguageSelector({
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return Column(
      children: [
        RadioListTile<Locale>(
          value: Locale('en', 'US'),
          groupValue: currentLocale,
          title: Text('English', style: TextStyle(color: theme.primaryColor)),
          onChanged: (Locale? selectedLocale) {
            if (selectedLocale != null) {
              onLocaleChange(selectedLocale);
            }
          },
        ),
        RadioListTile<Locale>(
          value: Locale('id', 'ID'),
          groupValue: currentLocale,
          title: Text('Bahasa Indonesia', style: TextStyle(color: theme.primaryColor)),
          onChanged: (Locale? selectedLocale) {
            if (selectedLocale != null) {
              onLocaleChange(selectedLocale);
            }
          },
        ),
        // RadioListTile<Locale>(
        //   value: Locale('es', 'ES'),
        //   groupValue: currentLocale,
        //   title: Text('Español'),
        //   onChanged: (Locale? selectedLocale) {
        //     if (selectedLocale != null) {
        //       onLocaleChange(selectedLocale);
        //     }
        //   },
        // ),
      ],
    );
  }
}
