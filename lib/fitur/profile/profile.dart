import 'package:applicationenglish/fitur/profile/LenguageSetting.dart';
import 'package:applicationenglish/fitur/profile/provider/profileProv.dart';
import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'about_yeah.dart';
import 'edit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({Key? key, this.user}) : super(key: key);
  final user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickerImage(ImageSource source) async {
    Permission permission = (source == ImageSource.camera) ? Permission.camera : Permission.photos;
    PermissionStatus status = await permission.request();

    if (status.isGranted) {
      try {
        final pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        } else {
          _showDialog(context, "Tidak ada gambar", "Anda belum memilih gambar.");
        }
      } catch (e) {
        _showDialog(context, "Terjadi Kesalahan", "Gagal mengambil gambar: $e");
      }
    } else if (status.isDenied) {
      _showDialog(context, "Izin Diperlukan", "Akses ke galeri atau kamera diperlukan untuk melanjutkan.");
    } else if (status.isPermanentlyDenied) {
      _showDialog(context, "Izin Diperlukan", "Akses ke galeri atau kamera telah ditolak secara permanen. Silakan atur izin di pengaturan aplikasi.");
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    var firestore = Provider.of<FirestoreInterface>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Pilih dari Galeri'),
                                    onTap: () {
                                      _pickerImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_camera),
                                    title: const Text('Ambil Foto'),
                                    onTap: () {
                                      _pickerImage(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 60,
                        child: _image == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 60,
                              )
                            : ClipOval(
                                child: Image.file(
                                  _image!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${firestore.data?.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.user['email'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "profile_set".i18n(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LenguageSet()));
                },
                child: Text(
                  "profile_language".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Edit(data: {
                            "name": firestore.data?.name,
                            "telp": firestore.data?.telp
                          })));
                },
                child: Text(
                  "profile_edit".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const Divider(thickness: 3),
              const SizedBox(height: 20),
              Text(
                "profile_help".i18n(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _showDialog(context, "profile_requirement".i18n(), "profile_requirement_info".i18n());
                },
                child: Text(
                  "profile_requirement".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _showDialog(context, "profile_center".i18n(), "profile_center_info".i18n());
                },
                child: Text(
                  "profile_center".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutYeah()));
                },
                child: Text(
                  "profile_about_us".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _showDialog(context, "profile_contact".i18n(), "profile_contact_info".i18n());
                },
                child: Text(
                  "profile_contact".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.primaryColor,
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
