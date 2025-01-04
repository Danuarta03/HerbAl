import 'package:herbal/core/API/produkApi.dart';

class ProdukModel {
  final String id_produk;
  final String id_kategori;
  final String nama_produk;
  final String harga;
  final String gambar;
  final int stock;
  final String deskripsi;
  final String manfaat;
  final String efekSamping;
  final String waktuKonsumsi;

  ProdukModel({
    required this.id_produk,
    required this.id_kategori,
    required this.nama_produk,
    required this.harga,
    required this.gambar,
    required this.stock,
    required this.deskripsi,
    required this.manfaat,
    required this.efekSamping,
    required this.waktuKonsumsi,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id_produk: json['id_produk']?.toString() ?? '',
      id_kategori: json['id_kategori']?.toString() ?? '',
      nama_produk: json['nama_produk']?.toString() ?? 'Tidak diketahui',
      harga: json['harga']?.toString() ?? 'Tidak ada harga',
      gambar: (json['gambar'] != null && json['gambar'].isNotEmpty)
          ? '$produkImageBaseUrl/${json['gambar']}'
          : '$produkImageBaseUrl/default.jpg',
      stock: json['stock'] != null ? int.tryParse(json['stock'].toString()) ?? 0 : 0,
      deskripsi: json['deskripsi']?.toString() ?? 'Tidak ada deskripsi',
      manfaat: json['manfaat']?.toString() ?? 'Tidak ada manfaat',
      efekSamping: json['efekSamping']?.toString() ?? 'Tidak ada efek samping',
      waktuKonsumsi: json['waktuKonsumsi']?.toString() ?? 'Tidak ada waktu konsumsi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_produk': id_produk,
      'id_kategori': id_kategori,
      'nama_produk': nama_produk,
      'harga': harga,
      'gambar': gambar.replaceFirst('$produkImageBaseUrl/', ''),
      'stock': stock,
      'deskripsi': deskripsi,
      'manfaat': manfaat,
      'efekSamping': efekSamping,
      'waktuKonsumsi': waktuKonsumsi,
    };
  }
}
