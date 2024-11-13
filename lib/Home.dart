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

class Home extends StatelessWidget {
  final dataUser;
  const Home({Key? key, this.dataUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              homeProvider.selectedIndex == 0 ? "Home" : "Profile",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => const HandlerButton()),
                MaterialPageRoute(builder: (context) => const Challange()),
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
              const Text(
                'Main Features',
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

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Column(
            children: [
              Text(
                'Welcome to Learning App',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Your gateway to knowledge',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildSwitchListTile(context),
          const Divider(
            endIndent: 25,
            thickness: 2,
            color: Colors.blue,
            height: 20,
          ),
          DrawerListTile(
            icon: Icons.info,
            title: 'About',
            page: AboutYeah(),
          ),
          const Divider(
            endIndent: 25,
            thickness: 2,
            color: Colors.blue,
            height: 20,
          ),
          ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.logout), 
              label: Text("Log Out"),
              ),
          const Divider(
            endIndent: 25,
            thickness: 2,
            color: Colors.blue,
            height: 20,
          ),
        ],
      ),
    );
  }

  SwitchListTile buildSwitchListTile(BuildContext context) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: Provider.of<SwitchModeProvider>(context).darkMode,
      onChanged: (bool val) {
        Provider.of<SwitchModeProvider>(context, listen: false).toggleTheme();
      },
    );
  }
}
