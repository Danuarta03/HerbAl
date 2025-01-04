import 'package:herbal/core/models/penyakit_model.dart';
import 'package:herbal/core/models/ramuan_model.dart';
import 'package:herbal/core/models/tanaman_model.dart';
import 'package:herbal/core/models/tips_model.dart';

class FavoritModel {
  final String id_favorit;
  final String id;
  final String id_ramuan;
  final String id_produk;
  final String id_tanaman;
  final String id_penyakit;
  final String id_tips;
  final RamuanModel? ramuan;
  final TanamanModel? tanaman;
  final PenyakitModel? penyakit;
  final TipsModel? tips;

  FavoritModel({
    required this.id_favorit,
    required this.id,
    required this.id_ramuan,
    required this.id_produk,
    required this.id_tanaman,
    required this.id_penyakit,
    required this.id_tips,
    this.ramuan,
    this.tanaman,
    this.penyakit,
    this.tips,
  });

  // Factory constructor untuk memparsing JSON ke dalam objek FavoritModel
  factory FavoritModel.fromJson(Map<String, dynamic> json) {
    return FavoritModel(
      id_favorit: json['id_favorit']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      id_ramuan: json['id_ramuan']?.toString() ?? '',
      id_produk: json['id_produk']?.toString() ?? '',
      id_tanaman: json['id_tanaman']?.toString() ?? '',
      id_penyakit: json['id_penyakit']?.toString() ?? '',
      id_tips: json['id_tips']?.toString() ?? '',
      ramuan: json['ramuan'] != null ? RamuanModel.fromJson(json['ramuan']) : null,
      tanaman: json['tanaman'] != null ? TanamanModel.fromJson(json['tanaman']) : null,
      penyakit: json['penyakit'] != null ? PenyakitModel.fromJson(json['penyakit']) : null,
      tips: json['tips'] != null ? TipsModel.fromJson(json['tips']) : null,
    );
  }



  // Untuk mengubah objek menjadi map (jika perlu dikirimkan dalam request)
  Map<String, dynamic> toJson() {
    return {
      'id_favorit': id_favorit,
      'id': id,
      'id_ramuan': id_ramuan,
      'id_produk': id_produk,
      'id_tanaman': id_tanaman,
      'id_penyakit': id_penyakit,
      'id_tips': id_tips,
    };
  }
}
