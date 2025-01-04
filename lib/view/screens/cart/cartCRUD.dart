// import 'package:flutter/material.dart';
// import 'package:herbal/core/API/keranjangApi.dart';
// import 'package:herbal/core/models/keranjang_model.dart';

// Future<void> handleTambahKeKeranjang(BuildContext context, KeranjangModel keranjang) async {
//   try {
//     final response = await ApiServiceKeranjang().tambahKeKeranjang(keranjang);
//     if (response.success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Produk berhasil ditambahkan ke keranjang!")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Gagal menambahkan produk ke keranjang: ${response.message}")),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Terjadi kesalahan: $e")),
//     );
//   }
// }

// Future<void> handleEditJumlahKeranjang(
//     BuildContext context, String id, int jumlah) async {
//   try {
//     // Panggil API untuk memperbarui keranjang
//     final response = await ApiServiceKeranjang().updateKeranjang(
//       idKeranjang: int.parse(id),
//       jumlah: jumlah,
//     );

//     // Tampilkan hasil berdasarkan respons
//     if (response.success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Jumlah produk berhasil diperbarui!")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Gagal memperbarui jumlah produk: ${response.message}"),
//         ),
//       );
//     }
//   } catch (e) {
//     // Tangani error
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Terjadi kesalahan: $e")),
//     );
//   }
// }


// Future<void> handleHapusDariKeranjang(BuildContext context, String id) async {
//   try {
//     final response = await ApiServiceKeranjang().deleteKeranjang(int.parse(id));
//     if (response.success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Produk berhasil dihapus dari keranjang!")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Gagal menghapus produk dari keranjang: ${response.message}")),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Terjadi kesalahan: $e")),
//     );
//   }
// }
