import 'package:herbal/core/API/kategoriApi.dart';

class KategoriModel {
  final String id_kategori;
  final String nama_kategori;
  final String gambar;

  KategoriModel({
    required this.id_kategori,
    required this.nama_kategori,
    required this.gambar,
  });

  // Membuat factory constructor untuk memparsing JSON ke dalam objek KategoriModel
  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id_kategori: json['id_kategori']?.toString() ?? '', 
      nama_kategori: json['nama_kategori'] ?? 'Tidak diketahui', 
      gambar: json['gambar']?.isNotEmpty == true
          ? '$kategoriImageBaseUrl/${json['gambar']}' 
          : '$kategoriImageBaseUrl/default.jpg', 
    );
  }

  // Untuk mengubah objek menjadi map (jika perlu dikirimkan dalam request)
  Map<String, dynamic> toJson() {
    return {
      'id_kategori': id_kategori, 
      'nama_kategori': nama_kategori,
      'gambar': gambar.replaceFirst('$kategoriImageBaseUrl/', ''), 
    };
  }
}
