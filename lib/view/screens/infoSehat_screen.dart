import 'package:flutter/material.dart';
import 'package:herbal/core/services/loading_manager.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/models/penyakit_model.dart';
import 'package:herbal/core/models/ramuan_model.dart';
import 'package:herbal/core/models/tanaman_model.dart';
import 'package:herbal/core/models/tips_model.dart';
import 'package:herbal/view/screens/searchBar.dart';
import 'package:herbal/view/widgets/layout/penyakit.dart';
import 'package:herbal/view/widgets/layout/ramuanKat.dart';
import 'package:herbal/view/widgets/layout/tanamanObat.dart';
import 'package:herbal/view/widgets/layout/tips_sehat.dart';
import 'package:herbal/core/API/tanamanApi.dart';
import 'package:herbal/core/API/ramuanApi.dart';
import 'package:herbal/core/API/penyakitApi.dart';
import 'package:herbal/core/API/tipsApi.dart';

class InfoSehatScreen extends StatelessWidget {
  const InfoSehatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: SearchBarWidget(controller: searchController),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Akses Berbagai Jenis Tanaman Obat",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildFutureSection<TanamanModel>(
                context,
                future: getTanaman(),
                title: "Tanaman Obat",
                itemTitle: (item) => item.nama_tanaman,
                itemImage: (item) => item.gambar,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TanamanObat(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Ramuan Tradisional",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildFutureSection<RamuanModel>(
                context,
                future: getRamuan(),
                title: "Ramuan Tradisional",
                itemTitle: (item) => item.nama_ramuan,
                itemImage: (item) => item.gambar,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RamuanKat(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Penyakit dan Ramuannya",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildFutureSection<PenyakitModel>(
                context,
                future: getPenyakit(),
                title: "Penyakit dan Ramuannya",
                itemTitle: (item) => item.nama_penyakit,
                itemImage: (item) => item.gambar,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PenyakitRamuan(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Tips Ringan Kesehatan",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildFutureSection<TipsModel>(
                context,
                future: getTips(),
                title: "Tips Ringan Kesehatan",
                itemTitle: (item) => item.nama_tips,
                itemImage: (item) => item.gambar,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Tips_Sehat(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFutureSection<T>(
    BuildContext context, {
    required Future<List<T>> future,
    required String title,
    required String Function(T item) itemTitle,
    required String Function(T item) itemImage,
    required VoidCallback onPressed,
  }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        FutureBuilder<List<T>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingManager(
                isLoading: true,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada $title.'));
            }

            List<T> items = snapshot.data!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length < 2 ? items.length : 2,
                (index) {
                  final item = items[index];
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Colors.grey.withOpacity(0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isDarkMode ? Colors.white : Colors.grey.shade300,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(itemImage(item)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  itemTitle(item),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text("Lihat semua $title"),
          ),
        ),
      ],
    );
  }
}
