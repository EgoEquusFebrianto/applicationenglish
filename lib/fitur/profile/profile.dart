import 'package:applicationenglish/fitur/profile/provider/profileProv.dart';
import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  File? _image; // File untuk menyimpan gambar yang dipilih

  // /// Fungsi untuk memeriksa dan meminta izin
  // Future<bool> _checkAndRequestPermissions(Permission permission) async {
  //   PermissionStatus status = await permission.request();
  //   return status.isGranted;
  // }

  // Future<bool> _checkAndRequestPermissions(Permission permission) async {
  //   PermissionStatus status = await permission.status;

  //   if (status.isGranted) {
  //     return true;
  //   } else if (status.isDenied || status.isLimited) {
  //     status = await permission.request();
  //     return status.isGranted;
  //   } else if (status.isPermanentlyDenied) {
  //     await openAppSettings();
  //     return false;
  //   }
  //   return false;
  // }

  Future<void> _pickImage1(ImageSource source) async {
    try {
      final picker = ImagePicker();
      var pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        _showDialog(context, "Tidak ada gambar", "Anda belum memilih gambar.");
      }
    } catch (e) {
      _showDialog(context, "Izin Diperlukan", "Akses ke galeri diperlukan untuk melanjutkan.");
    }
  }

  /// Fungsi untuk mengambil gambar dari sumber yang dipilih
Future<void> _pickImage2(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  Permission permission =
      (source == ImageSource.camera) ? Permission.camera : Permission.storage;

  // Meminta izin sesuai dengan sumber gambar
  PermissionStatus status = await permission.request();

  if (status.isGranted) {
    try {
      final pickedFile = await _picker.pickImage(source: source);
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


  /// Fungsi untuk menampilkan dialog informasi
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
                                      _pickImage1(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_camera),
                                    title: const Text('Ambil Foto'),
                                    onTap: () {
                                      _pickImage2(ImageSource.camera);
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
                "Pengaturan",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
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
                  "Edit Profile",
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
                "Bantuan & Informasi",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _showDialog(context, "Syarat dan Ketentuan",
                      "Terima kasih telah menggunakan aplikasi kami. Harap dibaca dan pahami syarat dan ketentuan berikut sebelum menggunakan layanan kami:\n\n1. Penggunaan aplikasi ini tunduk pada syarat dan ketentuan yang berlaku.\n\n2. Kami menghargai privasi Anda dan akan melindungi data pribadi sesuai dengan kebijakan privasi kami.\n\n3. Setiap penggunaan yang melanggar ketentuan dapat mengakibatkan pembatasan akses atau penghentian layanan.\n\nTerima kasih atas perhatian Anda.");
                },
                child: Text(
                  "Syarat Dan Ketentuan",
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
                  _showDialog(context, "Pusat Bantuan",
                      "Selamat datang di Pusat Bantuan kami.\n\nKami siap membantu Anda dengan segala pertanyaan atau masalah yang Anda miliki terkait penggunaan aplikasi kami.\n\nSilakan cari jawaban untuk pertanyaan umum di bagian FAQ kami.\n\nJika Anda tidak menemukan jawaban yang Anda cari, jangan ragu untuk menghubungi tim dukungan kami melalui email atau telepon yang tertera di halaman kontak aplikasi.\n\nTerima kasih.");
                },
                child: Text(
                  "Pusat Bantuan",
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
                  "Tentang Kami",
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
                  _showDialog(context, "Contact Person",
                      "Berikut adalah informasi kontak kami untuk pertanyaan lebih lanjut:\n\nNama: TIM L\nEmail: MahasiswaSmster4@mikroskil.ac.id\nTelepon: 082234548960\n\nJangan ragu untuk menghubungi kami jika Anda memiliki pertanyaan atau membutuhkan bantuan lebih lanjut.\n\nTerima kasih.");
                },
                child: Text(
                  "Contact Person",
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
