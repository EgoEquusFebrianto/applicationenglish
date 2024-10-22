import 'package:flutter/material.dart';
import 'provider/profil_prov.dart';
import 'package:provider/provider.dart';

class Edit extends StatelessWidget {
  const Edit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Consumer<ProfilProv>(
          builder: (context, value, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: value.profil.length,
                itemBuilder: (context, index) {
                  final nama =
                      TextEditingController(text: value.profil[index].nama);
                  final email =
                      TextEditingController(text: value.profil[index].email);
                  final alamat =
                      TextEditingController(text: value.profil[index].alamat);
                  final picture =
                      TextEditingController(text: value.profil[index].picture);
                  return Container(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        TextField(
                          controller: nama,
                          decoration: InputDecoration(
                            labelText: "Nama",
                            hintText: "Masukkan Nama",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height:30),
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Masukkan Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height:30),
                        TextField(
                          controller: alamat,
                          decoration: InputDecoration(
                            labelText: "Alamat",
                            hintText: "Masukkan Alamat",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height:30),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              value.updateProfil(CekProfil(
                                nama: nama.text,
                                email: email.text,
                                alamat: alamat.text,
                                picture: picture.text,
                                noTelp: value.profil[index].noTelp, 
                              ));
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ));
  }
}
