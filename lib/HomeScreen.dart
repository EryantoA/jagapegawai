// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jagapegawai/AddPegawaiScreen.dart';
import 'package:jagapegawai/Edit_Screen.dart';
import 'package:jagapegawai/Style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool loading = false;
List pegawaiList = [];

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getJsonFormApi();
    setState(() {});
  }

  Future<void> getJsonFormApi() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await get(
          Uri.parse("https://61601920faa03600179fb8d2.mockapi.io/pegawai"));
      print(response.body);
      print(response.statusCode);

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to variabel list _get
        setState(() {
          pegawaiList = data;
        });
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void myDialogBox(int index, id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete!",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: ColorRed),
        ),
        content: const Text("Are you sure delete this?"),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          OutlinedButton(
            onPressed: () async {
              final response = await delete(Uri.parse(
                  "https://61601920faa03600179fb8d2.mockapi.io/pegawai/" + id));

              if (response.statusCode == 200) {
                final data = jsonDecode(response.body);

                // entry data to variabel list _get
                setState(() {
                  // pegawaiList.removeAt(index);
                  pegawaiList[index][id] = data;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Data Pegawai Berhasil Dihapus",
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
                });
              }
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: ColorRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("List Pegawai"),
        ),
        body: pegawaiList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: getJsonFormApi,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 250),
                        itemCount: pegawaiList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorWhite,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54.withOpacity(0.2),
                                      blurRadius: 10)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 5),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                    ),
                                    child: Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Nama Pegawai : ${pegawaiList[index]['nama'] ?? "Unknown"}"),
                                            const SizedBox(height: 1),
                                            Text(
                                                "Provinsi : ${pegawaiList[index]['provinsi'] ?? "Unknown"}"),
                                            const SizedBox(height: 1),
                                            Text(
                                                "Kabupaten : ${pegawaiList[index]['kabupaten'] ?? "Unknown"}"),
                                            const SizedBox(height: 1),
                                            Text(
                                                "Kelurahan : ${pegawaiList[index]['kelurahan'] ?? "Unknown"}"),
                                            const SizedBox(height: 1),
                                            Text(
                                                "Jalan : ${pegawaiList[index]['jalan'] ?? "Unknown"}"),
                                            const SizedBox(height: 1),
                                            Text(
                                                "Kota : ${pegawaiList[index]['kota'] ?? "Unknown"}"),
                                            const SizedBox(height: 1),
                                            Text(
                                                "Name : ${pegawaiList[index]['name'] ?? "Unknown"}"),
                                          ]),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                  id: pegawaiList[index]["id"]),
                                            ),
                                          );
                                        },
                                        child: const Text("Edit"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            loading = true;

                                            myDialogBox(index,
                                                pegawaiList[index]["id"]);

                                            loading = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorRed),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: ColorDarkBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          icon: const Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPegawaiScreen(),
              ),
            );

            if (result != null && result == true) {
              loading = true;
              getJsonFormApi();
            }
          },
          label: const Text(
            "Add",
            style: TextStyle(fontSize: 16),
          ),
        ));
  }
}
