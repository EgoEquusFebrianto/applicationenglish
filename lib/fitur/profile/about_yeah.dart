import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class AboutYeah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_about_us'.i18n(), style: theme.appBarTheme.titleTextStyle,),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.iconTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // IDK
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AboutUsSection(),
              const SizedBox(height: 30),
              WhyChoose(),
              const SizedBox(height: 30),
              TheTeamHeader(),
              const SizedBox(height: 30),
              FeaturesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutUsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'profile_about_us1'.i18n(),
              style: TextStyle(fontSize: 16, color: theme.primaryColor),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}

class WhyChoose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'profile_about_us2'.i18n(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'profile_about_us3'.i18n(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
              subtitle: Text(
                'profile_about_us4'.i18n(),
                style: TextStyle(fontSize: 16, color: theme.primaryColor),
                textAlign: TextAlign.justify,
              ),
            ),
            ListTile(
              title: Text(
                'profile_about_us5'.i18n(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
              subtitle: Text(
                'profile_about_us6'.i18n(),
                style: TextStyle(fontSize: 16, color: theme.primaryColor),
                textAlign: TextAlign.justify,
              ),
            ),
            ListTile(
              title: Text(
                'profile_about_us7'.i18n(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
              subtitle: Text(
                'profile_about_us8'.i18n(),
                style: TextStyle(fontSize: 16, color: theme.primaryColor),
                textAlign: TextAlign.justify,
              ),
            ),
            ListTile(
              title: Text(
                'profile_about_us9'.i18n(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
              subtitle: Text(
                'profile_about_us10'.i18n(),
                style: TextStyle(fontSize: 16, color: theme.primaryColor),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TheTeamHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return Align(
      alignment: Alignment.center,
      child: Text(
        'profile_about_us11'.i18n(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'profile_about_us13'.i18n(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.translate, color: theme.primaryColor,),
          title: Text(
            'profile_about_us14'.i18n(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor,),
          ),
          subtitle: Text(
            'profile_about_us15'.i18n(),
            style: TextStyle(fontSize: 16, color: theme.primaryColor,),
            textAlign: TextAlign.justify,
          ),
        ),
        ListTile(
          leading: Icon(Icons.spellcheck, color: Colors.blue),
          title: Text(
            'profile_about_us16'.i18n(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor,),
          ),
          subtitle: Text(
            'profile_about_us17'.i18n(),
            style: TextStyle(fontSize: 16, color: theme.primaryColor,),
            textAlign: TextAlign.justify,
          ),
        ),
        ListTile(
          leading: Icon(Icons.sentiment_satisfied, color: Colors.blue),
          title: Text(
            'profile_about_us18'.i18n(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor,),
          ),
          subtitle: Text(
            'profile_about_us19'.i18n(),
            style: TextStyle(fontSize: 16, color: theme.primaryColor,),
            textAlign: TextAlign.justify,
          ),
        ),
        ListTile(
          leading: Icon(Icons.book, color: Colors.blue),
          title: Text(
            'profile_about_us20'.i18n(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor,),
          ),
          subtitle: Text(
            'profile_about_us21'.i18n(),
            style: TextStyle(fontSize: 16, color: theme.primaryColor,),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
