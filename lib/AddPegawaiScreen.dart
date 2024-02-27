import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jagapegawai/HomeScreen.dart';
import 'package:jagapegawai/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPegawaiScreen extends StatefulWidget {
  const AddPegawaiScreen({Key? key}) : super(key: key);

  @override
  State<AddPegawaiScreen> createState() => _AddPegawaiScreenState();
}

class _AddPegawaiScreenState extends State<AddPegawaiScreen> {
  var namaController = TextEditingController();
  var jalanController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var loading = false;

  String baseUrl = "https://emsifa.github.io/api-wilayah-indonesia/api/";
  String? _valProvince, _valCity, _valKec, _valKel;

  List<dynamic> _dataProvince = [];
  List<dynamic> _dataCity = [];
  List<dynamic> _dataKec = [];
  List<dynamic> _dataKel = [];

  void getProvince() async {
    final response = await http.get(Uri.parse("${baseUrl}provinces.json"));
    var listData = jsonDecode(response.body);
    setState(() {
      _dataProvince = listData;
    });
  }

  void getCity(String idProvince) async {
    String apiUrl = "${baseUrl}regencies/$idProvince.json";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _dataCity = responseData;
      });
    }
  }

  void getKec(String idCity) async {
    String apiUrl = "${baseUrl}districts/$idCity.json";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _dataKec = responseData;
      });
    }
  }

  void getKel(String idKec) async {
    String apiUrl = "${baseUrl}villages/$idKec.json";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _dataKel = responseData;
      });
    }
  }

  String getProvinceNameById(String id) {
    var province = _dataProvince.firstWhere((element) => element['id'] == id,
        orElse: () => {});

    return province['name'] ?? '';
  }

  String getCityNameById(String id) {
    var city = _dataCity.firstWhere((element) => element['id'] == id,
        orElse: () => {});

    return city['name'] ?? '';
  }

  String getKecNameById(String id) {
    var kec =
        _dataKec.firstWhere((element) => element['id'] == id, orElse: () => {});

    return kec['name'] ?? '';
  }

  String getKelNameById(String id) {
    var kel =
        _dataKel.firstWhere((element) => element['id'] == id, orElse: () => {});

    return kel['name'] ?? '';
  }

  Future<void> shareSelectedNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('provinceName', getProvinceNameById(_valProvince!));
    await prefs.setString('cityName', getCityNameById(_valCity!));
    await prefs.setString('kecamatanName', getKecNameById(_valKec!));
    await prefs.setString('kelurahanName', getKelNameById(_valKel!));
  }

  @override
  void initState() {
    super.initState();
    getProvince();
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
                const Text("Pilih provinsi pegawai"),
                DropdownButton(
                  hint: const Text("Select Province"),
                  value: _valProvince,
                  items: _dataProvince.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text(item['name']),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _valProvince = value;
                      _valCity = null;
                    });
                    getCity(value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text("Pilih kota pegawai"),
                DropdownButton(
                  hint: const Text("Select City"),
                  value: _valCity,
                  items: _dataCity.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text("${item['name']}"),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _valCity = value;
                      _valKec = null;
                    });
                    getKec(value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text("Pilih Kecamatan pegawai"),
                DropdownButton(
                  hint: const Text("Select Kecamatan"),
                  value: _valKec,
                  items: _dataKec.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text("${item['name']}"),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _valKec = value;
                      _valKel = null;
                    });
                    getKel(value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text("Pilih Kelurahan pegawai"),
                DropdownButton(
                  hint: const Text("Select Kelurahan"),
                  value: _valKel,
                  items: _dataKel.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text("${item['name']}"),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _valKel = value;
                    });
                  },
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
                const SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorDarkBlue,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await shareSelectedNames();
                        await postFormApi(context);
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Create",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
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

  Future<void> postFormApi(BuildContext context) async {
    try {
      final uri =
          Uri.parse("https://61601920faa03600179fb8d2.mockapi.io/pegawai");

      final apiParams = {
        "nama": namaController.text.trim(),
        "provinsi": _valProvince!,
        "kabupaten": _valCity!,
        "kecamatan": _valKec!,
        "kelurahan": _valKel!,
        "jalan": jalanController.text.trim(),
      };

      final response = await http.post(
        uri,
        body: jsonEncode(apiParams),
      );

      if (response.statusCode == 201) {
        namaController.clear();
        jalanController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Data Pegawai Berhasil Ditambahkan",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: ColorDarkBlue,
          ),
        );
      } else {
        print('Failed to add data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating data: $e');
    }
  }
}
