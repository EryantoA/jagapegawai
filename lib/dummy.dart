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
  var jalanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    super.initState();
    getProvince();
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

          jalanController.text = data['jalan'];
        });
      }

      print("get edit data: ${response.body}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onUpdate(context, String id) async {
    try {
      final uri =
          Uri.parse("https://61601920faa03600179fb8d2.mockapi.io/pegawai/$id");

      final apiParams = {
        "nama": namaController.text.trim(),
        "provinsi": _valProvince,
        "kabupaten": _valCity,
        "kecamatan": _valKec,
        "kelurahan": _valKel,
        "jalan": jalanController.text.trim(),
      };

      final response = await http.put(
        uri,
        body: jsonEncode(apiParams),
      );

      print("Update API: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Data Pegawai Berhasil Diubah",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: ColorDarkBlue,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        _onUpdate(context, widget.id);
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Update",
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
}
