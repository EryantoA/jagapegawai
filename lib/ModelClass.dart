import 'dart:convert';

List<Pegawaikey> pegawaiFromJson(String str) =>
    List<Pegawaikey>.from(json.decode(str).map((x) => Pegawaikey.fromJson(x)));

String pegawaiToJson(List<Pegawaikey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pegawaikey {
  String? sId;
  String? nama;
  dynamic provinsi;
  dynamic kabupaten;
  String? kecamatan;
  dynamic kelurahan;
  String? jalan;
  String? kota;
  String? name;

  Pegawaikey({
    this.sId,
    this.nama,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
    this.kelurahan,
    this.jalan,
    this.kota,
    this.name,
  });

  Pegawaikey.fromJson(Map<String, dynamic> json) {
    sId = json['id'];
    nama = json['nama'];
    provinsi = json['provinsi'];
    kabupaten = json['kabupaten'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
    jalan = json['jalan'];
    kota = json['kota'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
        "id": sId,
        "nama": nama,
        "provinsi": provinsi,
        "kabupaten": kabupaten?.toJson(),
        "kecamatan": kecamatan,
        "kelurahan": kelurahan?.toJson(),
        "jalan": jalan,
        "kota": kota,
        "name": name,
      };
}
