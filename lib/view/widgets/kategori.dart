import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:herbal/core/API/kategoriApi.dart';
import 'package:herbal/core/services/loading_manager.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/models/kategori_model.dart';
import 'package:herbal/view/widgets/layout/ramuan.dart';

class Kategori_Widgets extends StatelessWidget {
  final int itemCount;

  const Kategori_Widgets({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scaffoldColor =
        isDarkMode ? AppColors.darkScaffoldColor : AppColors.lightScaffoldColor;
    final cardColor =
        isDarkMode ? AppColors.darkCardColor : AppColors.lightScaffoldColor;
    final textColor =
        isDarkMode ? AppColors.darkTextColor : AppColors.darkCardColor;

    return FutureBuilder<List<KategoriModel>>(
      future: getKategori(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingManager(
            isLoading: true,
            child: _buildKategoriContent([], scaffoldColor, cardColor, textColor),
          );
        }
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada kategori'));
        }
        else {
          List<KategoriModel> kategoriList =
              snapshot.data!.take(itemCount).toList();

          return LoadingManager(
            isLoading: false, 
            child: _buildKategoriContent(kategoriList, scaffoldColor, cardColor, textColor),
          );
        }
      },
    );
  }

  Widget _buildKategoriContent(List<KategoriModel> kategoriList, Color scaffoldColor, Color cardColor, Color textColor) {
    return Container(
      color: scaffoldColor, 
      height: 120, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal, 
        padding: const EdgeInsets.all(12), 
        itemCount: kategoriList.length,
        itemBuilder: (context, index) {
          return _buildCategoryItem(kategoriList[index], cardColor, textColor);
        },
      ),
    );
  }

  Widget _buildCategoryItem(KategoriModel kategori, Color cardColor, Color textColor) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RamuanTra(
                  id_kategori: kategori.id_kategori,
                  nama_kategori: kategori.nama_kategori,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: kategori.gambar,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, size: 60),
                        fit: BoxFit.contain,
                        height: 50,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        kategori.nama_kategori,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
