import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'englishStructuredSentences.dart';
import 'HandlerButton_prov.dart';
import '_services.dart';

class HandlerButton extends StatelessWidget {
  const HandlerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final handlerButtonProvider = Provider.of<HandlerButtonProvider>(context);
    final useState = Provider.of<ClickedButtonListProvider>(context);
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Handler Button', style: theme.appBarTheme.titleTextStyle,),
        // backgroundColor: theme.appBarTheme.backgroundColor,
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.iconTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCard(
                      "Beginner",
                      "assets/pict/icons/Beginner.jpg",
                      Icons.star,
                      () {
                        useState.setLevel(1);
                        handlerButtonProvider.navigateToPage(
                            context, ButtonTransfer());
                      },
                      isNetworkImage: false,
                    ),
                    const SizedBox(height: 25),
                    _buildCard(
                      "Intermediate",
                      "assets/pict/icons/Intermediate.jpg",
                      Icons.star,
                      () {
                        useState.setLevel(2);
                        handlerButtonProvider.navigateToPage(
                            context, ButtonTransfer());
                      },
                      isNetworkImage: false,
                    ),
                    const SizedBox(height: 25),
                    _buildCard(
                      "Advanced",
                      "assets/pict/icons/Upper-Intermediate.jpg",
                      Icons.star,
                      () {
                        useState.setLevel(3);
                        handlerButtonProvider.navigateToPage(
                            context, ButtonTransfer());
                      },
                      isNetworkImage: false,
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
          if (handlerButtonProvider.loading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(
      String title, String imageUrl, IconData icon, VoidCallback onPressed,
      {bool isNetworkImage = true}) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 225,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: isNetworkImage
                  ? NetworkImage(imageUrl)
                  : AssetImage(imageUrl) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(icon, color: Colors.white),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
