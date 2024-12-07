import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page;

  const DrawerListTile({
    required this.icon,
    required this.title,
    required this.page,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
