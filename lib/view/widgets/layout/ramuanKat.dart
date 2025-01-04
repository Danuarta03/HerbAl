import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/API/kategoriApi.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/models/kategori_model.dart';
import 'package:herbal/view/widgets/layout/ramuan.dart';

class RamuanKat extends StatefulWidget {
  const RamuanKat({super.key});

  @override
  _RamuanKatState createState() => _RamuanKatState();
}

class _RamuanKatState extends State<RamuanKat> {
  late Future<List<KategoriModel>> _kategoriFuture;

  @override
  void initState() {
    super.initState();
    _kategoriFuture = getKategori();
  }

  @override
  Widget build(BuildContext conntext) {
  
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_back, color: Colors.white),
        ),
        backgroundColor: isDarkMode
            ? AppColors.darkPrimary
            : AppColors.lightPrimary, 
        title: const Text(
          "Jenis Ramuan Tradisional",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder<List<KategoriModel>>(
            future: _kategoriFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data kategori.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return KategoriCard(
                      kategori: snapshot.data![index],
                      isDarkMode: isDarkMode, 
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      backgroundColor: isDarkMode
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor, 
    );
  }
}

class KategoriCard extends StatelessWidget {
  final KategoriModel kategori;
  final bool isDarkMode;

  const KategoriCard({super.key, required this.kategori, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkCardColor
              : AppColors.lightScaffoldColor, 
          borderRadius: BorderRadius.circular(15),
          boxShadow: isDarkMode
              ? []
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(kategori.gambar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12), 
            Expanded(
              child: Text(
                kategori.nama_kategori,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppColors.darkTextColor
                      : Colors.black, 
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: isDarkMode ? Colors.grey : Colors.black38, 
            ),
          ],
        ),
      ),
    );
  }
}
