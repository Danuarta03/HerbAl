import 'package:herbal/core/models/produk_model.dart';

class KeranjangModel {
  final int id_keranjang; 
  final String idUser; 
  final String idProduk; 
  final int jumlah; 
  ProdukModel produk; 

  KeranjangModel({
    required this.id_keranjang,
    required this.idUser,
    required this.idProduk,
    required this.jumlah,
    required this.produk,
  });

  factory KeranjangModel.fromJson(Map<String, dynamic> json) {
    return KeranjangModel(
      id_keranjang: json['id_keranjang'] ?? 0, 
      idUser: json['id_user']?.toString() ?? '',
      idProduk: json['id_produk']?.toString() ?? '',
      jumlah: json['jumlah'] ?? 0,
      produk: ProdukModel.fromJson(json['produk'] ?? {}),
    );
  }

  Map<String, dynamic> toJson({bool includeProduk = false}) {
    final data = {
      'id_keranjang': id_keranjang,
      'id_user': idUser,
      'id_produk': idProduk,
      'jumlah': jumlah,
    };
    if (includeProduk) {
      data['produk'] = produk.toJson();
    }
    return data;
  }
}
