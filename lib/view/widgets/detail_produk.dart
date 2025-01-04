import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:herbal/core/API/keranjangApi.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/models/keranjang_model.dart';
import 'package:herbal/core/models/produk_model.dart';
import 'package:herbal/core/utility/SharedPreferences.dart';

class DetailProduk extends StatefulWidget {
  final ProdukModel produk;

  const DetailProduk({super.key, required this.produk});

  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  bool isFavorited = false;
  int jumlah = 1;
  String userId = "";
  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    final id = await SharedPreferencesHelper.getUserId();
    if (id != null) {
      setState(() {
        userId = id;
      });
    } else {
      print("ID user tidak ditemukan. Pastikan pengguna sudah login.");
    }
  }


  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  Future<void> handleTambahKeKeranjang() async {
    if (userId.isEmpty) {
      Fluttertoast.showToast(
        msg: "ID user tidak ditemukan. Silakan login terlebih dahulu.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
  
  final keranjang = KeranjangModel(
      id_keranjang: 0,
      idUser: userId,
      idProduk: widget.produk.id_produk,
      jumlah: jumlah,
      produk: widget.produk,
    );
  
  try {
      final apiService = ApiServiceKeranjang();
      final response = await apiService.tambahKeKeranjang(keranjang);

      if (response.success) {
        Fluttertoast.showToast(
          msg: "Produk berhasil ditambahkan ke keranjang!",
          backgroundColor: const Color.fromRGBO(6, 132, 0, 1),
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Gagal menambahkan ke keranjang: ${response.message}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final produk = widget.produk;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkScaffoldColor : AppColors.lightScaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: AppBar(
          backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
          elevation: 0,
          toolbarHeight: 20,
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(CupertinoIcons.chevron_back),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: toggleFavorite,
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorited ? Colors.red : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                child: Image.network(
                  produk.gambar,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Text(
                    produk.nama_produk,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      "Rp. ${produk.harga}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkCardColor : AppColors.lightCardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    produk.deskripsi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Manfaat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produk.manfaat,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Efek Samping',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produk.efekSamping,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Waktu Konsumsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produk.waktuKonsumsi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: isDarkMode ? AppColors.darkCardColor : Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(Icons.chat, color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary, size: 28),
                onPressed: () {},
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: isDarkMode ? Colors.white30 : Colors.grey,
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary, size: 28),
                onPressed: () {
                    handleTambahKeKeranjang();
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: ElevatedButton(
                onPressed: () {
                
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                  ),
                ),
                child: const Text(
                  'Beli Sekarang',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}