import 'package:applicationenglish/fitur/profile/provider/profileProv.dart';
import 'package:applicationenglish/fitur/treasure/animated_button.dart';
import 'package:applicationenglish/fitur/treasure/video_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_provider.dart';
import 'fitur/Challanges/Sentences/HandlerButton.dart';
import 'fitur/Challanges/TranslateGames/button_translate.dart';
import 'fitur/profile/profile.dart';
import 'fitur/profile/provider/switchProvider.dart';
import 'fitur/profile/about_yeah.dart';
import 'fitur/login_and_regist/login.dart';
import 'fitur/providers/translation_provider.dart';
import 'fitur/feature_card.dart';
import 'fitur/drawer_list_tile.dart';
import 'fitur/translation_card.dart';
import 'fitur/custom_bottom_navigation_bar.dart';
import 'fitur/Challanges/tmp.dart';
import 'package:localization/localization.dart';

class Home extends StatelessWidget {
  final dataUser;
  final uid;
  const Home({Key? key, this.dataUser, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    var firestore = Provider.of<FirestoreInterface>(context);

    Future.microtask(() {
      if (firestore.uid == "") firestore.setUid(uid);
      if (firestore.data == null) firestore.catchUser();
    });

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              homeProvider.selectedIndex == 0
                  ? "home_header1".i18n()
                  : "home_header2".i18n(),
              style: theme.appBarTheme.titleTextStyle,
              // style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: theme.appBarTheme.backgroundColor,
            iconTheme: theme.iconTheme,
            // backgroundColor: Colors.blue,
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: buildDrawer(context),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => const HandlerButton()),
                MaterialPageRoute(builder: (context) => Challange()),
              );
            },
            child: const Icon(Icons.backup_table_sharp),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          body: bodyPage(context, homeProvider.selectedIndex),
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: homeProvider.selectedIndex,
            onItemTapped: (index) => homeProvider.setSelectedIndex(index),
          ),
        );
      },
    );
  }

  Widget bodyPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  _buildFeatureCard(context),
                  const SizedBox(height: 20),
                  _buildTranslationCard(context),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      case 1:
        return Profile(user: dataUser);
      default:
        return Container();
    }
  }

  Widget _buildFeatureCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      shadowColor: Colors.black54,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "home_MainFiture".i18n(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  FeatureCard(
                    icon: Icons.display_settings_rounded,
                    title: 'Word Display',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HandlerButton(),
                        ),
                      );
                    },
                    backgroundImage:
                        const AssetImage('assets/pict/icons/sentences.jpeg'),
                    isNetworkImage: true,
                  ),
                  FeatureCard(
                    icon: Icons.touch_app_outlined,
                    title: 'Button Translate',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ButtonTranslate(),
                        ),
                      );
                    },
                    backgroundImage: const AssetImage(
                        'assets/pict/icons/button translate.webp'),
                    isNetworkImage: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationCard(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, translationProvider, child) {
        return TranslationCard(
          controller: Provider.of<HomeProvider>(context).controller,
          sourceLanguage: translationProvider.sourceLanguage,
          targetLanguage: translationProvider.targetLanguage,
          translatedText: translationProvider.translatedText,
          onSourceLanguageChanged: (value) {
            if (value != null) {
              translationProvider.setSourceLanguage(value);
            }
          },
          onTargetLanguageChanged: (value) {
            if (value != null) {
              translationProvider.setTargetLanguage(value);
            }
          },
          onTranslatePressed: () =>
              Provider.of<HomeProvider>(context, listen: false)
                  .translateText(context),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              print("Button 1 Pressed!");
              videoProvider.setIsolated(1);
              videoProvider.setSession(1);
            },
            child: Text('WIP'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              print("Button 2 Pressed!");
              videoProvider.setIsolated(1);
              videoProvider.setSession(1);
            },
            child: Text('WIP'),
          ),
          AnimatedButtonChest(),
        ],
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return Drawer(
      backgroundColor: theme.colorScheme.onPrimary,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                "home_welcome".i18n(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              Text(
                'home_greeting'.i18n(),
                style: TextStyle(
                  fontSize: 14,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildSwitchListTile(context),
          Divider(
            endIndent: 25,
            thickness: 2,
            color: theme.colorScheme.primary,
            height: 20,
          ),
          DrawerListTile(
            icon: Icons.info,
            title: 'home_info'.i18n(),
            page: AboutYeah(),
          ),
          Divider(
            endIndent: 25,
            thickness: 2,
            color: theme.colorScheme.primary,
            height: 20,
          ),
          buildLogOutAction(context),
          Divider(
            endIndent: 25,
            thickness: 2,
            color: theme.colorScheme.primary,
            height: 20,
          ),
        ],
      ),
    );
  }

  SwitchListTile buildSwitchListTile(
    BuildContext context,
  ) {
    var theme = Provider.of<SwitchModeProvider>(context);
    return SwitchListTile(
      title: Text('home_mode'.i18n(),
          style: TextStyle(
            color: theme.themeData.primaryColor,
          )),
      value: theme.darkMode,
      onChanged: (bool val) {
        Provider.of<SwitchModeProvider>(context, listen: false).toggleTheme();
      },
    );
  }

  Widget buildLogOutAction(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide.none,
          ),
          elevation: 0,
          textStyle: TextStyle(
              color: theme.primaryColor, fontWeight: FontWeight.bold)),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
      icon: Icon(Icons.logout),
      label: Text("home_exit".i18n()),
    );
  }
}
