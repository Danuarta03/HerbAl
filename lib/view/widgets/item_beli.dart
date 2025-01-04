import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/models/produk_model.dart';
import 'package:herbal/view/screens/auth/welcome.dart';
import 'package:herbal/view/widgets/detail_produk.dart';

class ItemBeliWidget extends StatefulWidget {
  final List<ProdukModel> produkList;

  const ItemBeliWidget({super.key, required this.produkList});

  @override
  State<ItemBeliWidget> createState() => _ItemBeliWidgetState();
}

class _ItemBeliWidgetState extends State<ItemBeliWidget> {
  final Map<int, bool> _favorites = {};

  void toggleFavorite(int index) {
    setState(() {
      _favorites[index] = !(_favorites[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 170 / 280,
      ),
      itemCount: widget.produkList.length,
      itemBuilder: (context, i) {
        final produk = widget.produkList[i];
        final isFavorited = _favorites[i] ?? false;

        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isDarkMode ? AppColors.darkCardColor : AppColors.darkTextColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -10,
                right: -10,
                child: GestureDetector(
                  onTap: () => toggleFavorite(i),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: isFavorited ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.network(
                        produk.gambar,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      produk.nama_produk,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                        fontSize: produk.nama_produk.length > 20 ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Text(
                    "Rp. ${produk.harga}",
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (user == null) {
                          // Jika user belum login, arahkan ke WelcomeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                          );
                        } else {
                          // Jika user sudah login, arahkan ke DetailProduk
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailProduk(produk: produk),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text(
                        "Beli",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
