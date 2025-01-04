import 'package:herbal/core/API/penyakitApi.dart';

class PenyakitModel {
  final String id_penyakit;
  final String nama_penyakit;
  final String gambar;
  final String deskripsi;
  final String penyebab;
  final String gejala;
  final String pantangan;
  final String anjuran;

  PenyakitModel({
    required this.id_penyakit,
    required this.nama_penyakit,
    required this.gambar,
    required this.deskripsi,
    required this.penyebab,
    required this.gejala,
    required this.pantangan,
    required this.anjuran,
  });

  // Membuat factory constructor untuk memparsing JSON ke dalam objek 
  factory PenyakitModel.fromJson(Map<String, dynamic> json) {
    return PenyakitModel(
      id_penyakit: json['id_penyakit']?.toString() ?? '',
      nama_penyakit: json['nama_penyakit'] ?? 'Tidak diketahui', 
      gambar: json['gambar']?.isNotEmpty == true
          ? '$penyakitImageBaseUrl/${json['gambar']}'
          : '$penyakitImageBaseUrl/default.jpg', 
      deskripsi: json['deskripsi'] ?? 'Tidak ada deskripsi',
      penyebab: json['penyebab'] ?? 'Tidak ada penyebab',
      gejala: json['gejala'] ?? 'Tidak ada gejala',
      pantangan: json['pantangan'] ?? 'Tidak ada pantangan',
      anjuran: json['anjuran'] ?? 'Tidak ada anjuran',
    );
  }

  // Untuk mengubah objek menjadi map (jika perlu dikirimkan dalam request)
  Map<String, dynamic> toJson() {
    return {
      'id_penyakit': id_penyakit, 
      'nama_penyakit': nama_penyakit,
      'gambar': gambar.replaceFirst('$penyakitImageBaseUrl/', ''),
      'deskripsi': deskripsi,
      'penyebab': penyebab,
      'gejala': gejala,
      'pantangan': pantangan,
      'anjuran': anjuran,
    };
  }
}
