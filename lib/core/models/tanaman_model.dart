import 'package:herbal/core/API/tanamanApi.dart';

class TanamanModel {
  final String id_tanaman;
  final String nama_tanaman;
  final String gambar;
  final String deskripsi;
  final String bagian_tumbuhan;
  final String khasiat;
  final String penggunaan;
  final String efekSamping;

  TanamanModel({
    required this.id_tanaman,
    required this.nama_tanaman,
    required this.gambar,
    required this.deskripsi,
    required this.bagian_tumbuhan,
    required this.khasiat,
    required this.penggunaan,
    required this.efekSamping,
  });

  // Membuat factory constructor untuk memparsing JSON ke dalam objek tanamanModel
  factory TanamanModel.fromJson(Map<String, dynamic> json) {
    return TanamanModel(
      id_tanaman: json['id_tanaman']?.toString() ?? '', 
      nama_tanaman: json['nama_tanaman'] ?? 'Tidak diketahui', 
      gambar: json['gambar']?.isNotEmpty == true
          ? '$tanamanImageBaseUrl/${json['gambar']}' 
          : '$tanamanImageBaseUrl/default.jpg',
      deskripsi: json['deskripsi'] ?? 'Tidak diketahui',
      bagian_tumbuhan: json['bagian_tumbuhan'] ?? 'Tidak diketahui', 
      khasiat: json['khasiat'] ?? 'Tidak diketahui',
      penggunaan: json['penggunaan'] ?? 'Tidak diketahui',
      efekSamping: json['efekSamping'] ?? 'Tidak diketahui',
    );
  }
  
  // Untuk mengubah objek menjadi map (jika perlu dikirimkan dalam request)
  Map<String, dynamic> toJson() {
    return {
      'id_tanaman': id_tanaman, 
      'nama_tanaman': nama_tanaman,
      'gambar': gambar.replaceFirst('$tanamanImageBaseUrl/', ''), 
      'deskripsi': deskripsi,
      'bagian_tumbuhan': bagian_tumbuhan,
      'khasiat': khasiat,
      'penggunaan': penggunaan,
      'efekSamping': efekSamping,
    };
  }
}