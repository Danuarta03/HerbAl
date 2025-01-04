import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:herbal/core/API/favoritApi.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/models/favorit_model.dart';
import 'package:herbal/core/models/penyakit_model.dart';
import 'package:herbal/core/utility/SharedPreferences.dart';

class Detail_Penyakit extends StatefulWidget {
  final PenyakitModel penyakit;
  const Detail_Penyakit({super.key, required this.penyakit});

  @override
  State<Detail_Penyakit> createState() => _Detail_PenyakitState();
}

class _Detail_PenyakitState extends State<Detail_Penyakit> {
  final ApiServiceFavorit _apiService = ApiServiceFavorit();
  bool isFavorited = false;
  String? userId;
  String? idFavorit; 

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _loadUserId();
      if (userId != null) {
        await _checkFavoriteStatus();
      }
    } catch (e) {
      print("Error initializing data: $e");
    }
  }

  Future<void> _loadUserId() async {
    try {
      final id = await SharedPreferencesHelper.getUserId();
      if (id != null) {
        setState(() {
          userId = id.toString();
        });
      }
    } catch (e) {
      print('Error loading user ID: $e');
    }
  }

  Future<void> _checkFavoriteStatus() async {
    if (userId == null) return;
    try {
      final favoritList = await _apiService.getFavorit(userId!);
      final penyakitId = widget.penyakit.id_penyakit.toString();

      FavoritModel? favorit;
      try {
        favorit = favoritList.firstWhere(
          (favorit) => favorit.id_penyakit == penyakitId,
        );
      } catch (e) {
        favorit = null; 
      }

      setState(() {
        isFavorited = favorit != null;
        idFavorit = favorit?.id_favorit; 
      });

      print('Status favorit $penyakitId: $isFavorited');
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _saveToFavorit() async {
  if (userId == null) {
    Fluttertoast.showToast(
      msg: "Anda belum login. Silakan login untuk menambahkan favorit.",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    return;
  }

  final favorit = FavoritModel(
    id_favorit: '',
    id: userId!,
    id_tanaman: '',
    id_ramuan: '',
    id_produk: '',
    id_penyakit: widget.penyakit.id_penyakit.toString(),
    id_tips: '',
  );

  try {
    final response = await _apiService.tambahFavorit(favorit);
    if (response.success) {
      setState(() {
        isFavorited = true;
        idFavorit = response.data?['id_favorit'] ?? ''; 
      });

      Fluttertoast.showToast(
        msg: "Berhasil ditambahkan ke favorit",
        backgroundColor: const Color.fromRGBO(6, 132, 0, 1),
        textColor: Colors.white,
      );
    } else {
      throw Exception("Respon tidak valid: ${response.message ?? 'Error tidak diketahui.'}");
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Gagal menambahkan ke favorit: ${e.toString()}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

  Future<void> _removeFromFavorit() async {
    if (userId == null) {
      Fluttertoast.showToast(
        msg: "Anda belum login. Silakan login untuk menghapus favorit.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (idFavorit == null) {
      Fluttertoast.showToast(
        msg: "ID Favorit tidak ditemukan.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final response = await _apiService.deleteFavorit(idFavorit!);
      if (response.success) {
        setState(() {
          isFavorited = false;
          idFavorit = null;
        });
        Fluttertoast.showToast(
          msg: "Berhasil dihapus dari favorit",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Gagal menghapus favorit: ${response.message}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal menghapus dari favorit: ${e.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void toggleFavorite() async {
    if (isFavorited) {
      await _removeFromFavorit();
    } else {
      await _saveToFavorit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkScaffoldColor : AppColors.lightScaffoldColor,
      body: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  widget.penyakit.gambar,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 30,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        fixedSize: const Size(50, 50),
                      ),
                      icon: const Icon(CupertinoIcons.chevron_back),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: toggleFavorite,
                      style: IconButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        isFavorited ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        color: isFavorited ? Colors.red : (isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.width * 3 / 4 - 20,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkCardColor : AppColors.lightScaffoldColor ,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                widget.penyakit.nama_penyakit,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black, 
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: widget.penyakit.deskripsi,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "a. Penyebab",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                          height: 1.5,
                        ),
                        text: widget.penyakit.penyebab,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "b. Gejala",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                          height: 1.5,
                        ),
                        text: widget.penyakit.gejala,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "c. Pantangan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                          height: 1.5,
                        ),
                        text: widget.penyakit.pantangan,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "d. Anjuran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                          height: 1.5,
                        ),
                        text: widget.penyakit.anjuran,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
