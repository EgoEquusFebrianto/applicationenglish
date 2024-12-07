import 'package:applicationenglish/fitur/profile/provider/profileProv.dart';
import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Edit extends StatefulWidget {
  final data;
  const Edit({Key? key, this.data}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  late TextEditingController namaController;
  late TextEditingController telpController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.data['name']);
    telpController = TextEditingController(text: widget.data['telp']);
  }

  @override
  void dispose() {
    // Pastikan controller dibersihkan ketika widget dihapus
    namaController.dispose();
    telpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.iconTheme,
        title: Text(
          "Edit Profile",
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              style: TextStyle(color: theme.colorScheme.secondary),
              decoration: InputDecoration(
                labelText: "Nama",
                hintText: "Masukkan Nama",
                labelStyle: TextStyle(color: theme.colorScheme.secondary),
                hintStyle: TextStyle(color: theme.colorScheme.secondary.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.secondary),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: telpController,
              style: TextStyle(color: theme.colorScheme.secondary),
              decoration: InputDecoration(
                labelText: "Telepon",
                hintText: "Masukkan Nomor Telepon",
                labelStyle: TextStyle(color: theme.colorScheme.secondary),
                hintStyle: TextStyle(color: theme.colorScheme.secondary.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.secondary),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (context.read<FirestoreInterface>().data != null) {
                    Map<String, dynamic> _data = {
                      "NewName": namaController.text,
                      "NewNumberPhone": telpController.text,
                    };
                    context.read<FirestoreInterface>().updateDocument(_data).then((_) {
                      context.read<FirestoreInterface>().fetchDocument();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully!')),
                    );

                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                    });
                  } else {
                    print("Data belum tersedia!");
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
