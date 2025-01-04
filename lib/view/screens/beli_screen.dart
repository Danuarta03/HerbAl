import 'package:flutter/material.dart';
import 'package:herbal/core/API/produkApi.dart';
import 'package:herbal/core/models/produk_model.dart';
import 'package:herbal/core/services/loading_manager.dart';
import 'package:herbal/view/screens/searchBar.dart';
import 'package:herbal/view/widgets/item_beli.dart';
import 'package:herbal/view/widgets/kategori.dart';

class BeliObatScreen extends StatelessWidget {
  const BeliObatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final int jumlahKategori = 3;

    return Scaffold(
      appBar: SearchBarWidget(controller: searchController),
      body: FutureBuilder<List<ProdukModel>>(
        future: getProduk(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingManager(
              isLoading: true, 
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada produk.'));
          }

          List<ProdukModel> produkList = snapshot.data!;

          return LoadingManager(
            isLoading: false, 
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Kategori Populer",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Kategori_Widgets(itemCount: jumlahKategori),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Produk Paling Dicari",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ItemBeliWidget(produkList: produkList), 
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
