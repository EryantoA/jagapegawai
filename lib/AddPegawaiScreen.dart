import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jagapegawai/HomeScreen.dart';
import 'package:jagapegawai/Style.dart';

class AddPegawaiScreen extends StatefulWidget {
  const AddPegawaiScreen({super.key});

  @override
  State<AddPegawaiScreen> createState() => _AddPegawaiScreenState();
}

class _AddPegawaiScreenState extends State<AddPegawaiScreen> {
  var namaController = TextEditingController();
  var provinsiController = TextEditingController();
  var kabupatenController = TextEditingController();
  var kecamatanController = TextEditingController();
  var kelurahanController = TextEditingController();
  var jalanController = TextEditingController();
  var kotaController = TextEditingController();
  var nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var loading = false;

  Future<void> postFormApi(context) async {
    setState(() {
      loading = true;
    });
    try {
      Uri uri =
          Uri.parse("https://61601920faa03600179fb8d2.mockapi.io/pegawai");

      Map<String, dynamic> apiParams = {
        "nama": namaController.text.trim(),
        "provinsi": provinsiController.text.trim(),
        "kabupaten": kabupatenController.text.trim(),
        "kecamatan": kecamatanController.text.trim(),
        "kelurahan": kelurahanController.text.trim(),
        "jalan": jalanController.text.trim(),
        "kota": kotaController.text.trim(),
        "name": nameController.text.trim(),
      };

      Response response = await post(
        uri,
        body: jsonEncode(apiParams),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        // Clear text controllers after successful submission
        namaController.clear();
        provinsiController.clear();
        kabupatenController.clear();
        kecamatanController.clear();
        kelurahanController.clear();
        jalanController.clear();
        kotaController.clear();
        nameController.clear();
      } else {
        // Handle other status codes if needed
        print('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating data: $e');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("Tambah Data Pegawai"),
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
                            backgroundColor: ColorDarkBlue),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              postFormApi(context);
                            });

                            // Display success snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Data Pegawai Berhasil Ditambahkan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                backgroundColor: ColorDarkBlue,
                              ),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          }
                        },
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Create",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
