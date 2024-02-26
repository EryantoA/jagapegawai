import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jagapegawai/HomeScreen.dart';
import 'package:jagapegawai/Style.dart';

class EditScreen extends StatefulWidget {
  final String id;

  const EditScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var namaController = TextEditingController();
  var provinsiController = TextEditingController();
  var kabupatenController = TextEditingController();
  var kecamatanController = TextEditingController();
  var kelurahanController = TextEditingController();
  var jalanController = TextEditingController();
  var kotaController = TextEditingController();
  var nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://61601920faa03600179fb8d2.mockapi.io/pegawai/${widget.id}"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          namaController.text = data['nama'];
          provinsiController.text = data['provinsi'];
          kabupatenController.text = data['kabupaten'];
          kecamatanController.text = data['kecamatan'];
          kelurahanController.text = data['kelurahan'];
          jalanController.text = data['jalan'];
          kotaController.text = data['kota'];
          nameController.text = data['name'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onUpdate(context) async {
    try {
      final response = await http.put(
        Uri.parse(
            "https://61601920faa03600179fb8d2.mockapi.io/pegawai/${widget.id}"),
        body: {
          "nama": namaController.text,
          "provinsi": provinsiController.text,
          "kabupaten": kabupatenController.text,
          "kecamatan": kecamatanController.text,
          "kelurahan": kelurahanController.text,
          "jalan": jalanController.text,
          "kota": kotaController.text,
          "name": nameController.text,
        },
      );

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Data Pegawai Berhasil Diubah",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: ColorDarkBlue,
          ),
        );

        // Navigate back to HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Handle other status codes if needed
        print('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("Update Data Pegawai"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter nama pegawai";
                    }
                    return null;
                  },
                  controller: namaController,
                  decoration: MyDecoration("Nama Pegawai"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter provinsi pegawai";
                    }
                    return null;
                  },
                  controller: provinsiController,
                  decoration: MyDecoration("Provinsi Pegawai"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter kabupaten pegawai";
                    }
                    return null;
                  },
                  controller: kabupatenController,
                  decoration: MyDecoration("Kabupaten Pegawai"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter kecamatan pegawai";
                    }
                    return null;
                  },
                  controller: kecamatanController,
                  decoration: MyDecoration("Kecamatan Pegawai"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Kelurahan Pegawai";
                    }
                    return null;
                  },
                  controller: kelurahanController,
                  decoration: MyDecoration("Kelurahan Pegawai"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter jalan Pegawai";
                    }
                    return null;
                  },
                  controller: jalanController,
                  decoration: MyDecoration("jalan Pegawai"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter kota Pegawai";
                    }
                    return null;
                  },
                  controller: kotaController,
                  decoration: MyDecoration("Kota Pegawai"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter name Pegawai";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: MyDecoration("name Pegawai"),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorDarkBlue,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onUpdate(context);
                      }
                    },
                    child: const Text(
                      "Update",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
