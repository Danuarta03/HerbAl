import 'package:herbal/core/API/ramuanApi.dart';

class RamuanModel {
  final String id_ramuan;
  final String id_kategori;
  final String nama_ramuan;
  final String gambar;
  final String deskripsi;
  final String manfaat;
  final String efekSamping;
  final String waktuKonsumsi;
  final String saranPenggunaan;
  final String bahan;
  final String langkahPembuatan;

  RamuanModel({
    required this.id_ramuan,
    required this.id_kategori,
    required this.nama_ramuan,
    required this.gambar,
    required this.deskripsi,
    required this.manfaat,
    required this.efekSamping,
    required this.waktuKonsumsi,
    required this.saranPenggunaan,
    required this.bahan,
    required this.langkahPembuatan,
  
  });

  // Membuat factory constructor untuk memparsing JSON ke dalam objek KategoriModel
  factory RamuanModel.fromJson(Map<String, dynamic> json) {
    return RamuanModel(
      id_ramuan: json['id_ramuan']?.toString() ?? '',
      id_kategori: json['id_kategori']?.toString() ?? '', 
      nama_ramuan: json['nama_ramuan'] ?? 'Tidak diketahui',
      gambar: json['gambar']?.isNotEmpty == true
          ? '$ramuanImageBaseUrl/${json['gambar']}' 
          : '$ramuanImageBaseUrl/default.jpg', 
      deskripsi: json['deskripsi'] ?? 'Tidak ada deskripsi',
      manfaat: json['manfaat'] ?? 'Tidak ada manfaat',
      efekSamping: json['efekSamping'] ?? 'Tidak ada efek samping',
      waktuKonsumsi: json['waktuKonsumsi'] ?? 'Tidak ada waktu konsumsi',
      saranPenggunaan: json['saranPenggunaan'] ?? 'Tidak ada saran penggunaan',
      bahan: json['bahan'] ?? 'Tidak ada bahan',
      langkahPembuatan: json['langkahPembuatan'] ?? 'Tidak ada langkah pembuatan',
    );
  }

  // Untuk mengubah objek menjadi map (jika perlu dikirimkan dalam request)
  Map<String, dynamic> toJson() {
    return {
      'id_ramuan': id_ramuan, 
      'id_kategori': id_kategori,
      'nama_ramuan': nama_ramuan,
      'gambar': gambar.replaceFirst('$ramuanImageBaseUrl/', ''), 
      'deskripsi': deskripsi,
      'manfaat': manfaat,
      'efekSamping': efekSamping,
      'waktuKonsumsi': waktuKonsumsi,
      'saranPenggunaan': saranPenggunaan,
      'bahan': bahan,
      'langkahPembuatan': langkahPembuatan,
    };
  }
}


