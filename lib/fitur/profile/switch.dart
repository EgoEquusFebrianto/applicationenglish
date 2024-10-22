import 'package:flutter/material.dart';
import 'provider/switchProvider.dart';
import 'package:provider/provider.dart';

class SwitchScreenMode extends StatelessWidget {
  const SwitchScreenMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                  title: Text(
                    'Dark Mode',
                  ),
                  value: Provider.of<SwitchModeProvider>(context, listen: false)
                      .darkMode,
                  onChanged: (bool val) {
                    Provider.of<SwitchModeProvider>(context, listen: false)
                        .toggleTheme();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
