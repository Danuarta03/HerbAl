import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:herbal/core/API/tipsApi.dart'; 
import 'package:herbal/core/API/tanamanApi.dart'; 
import 'package:herbal/core/models/tanaman_model.dart';
import 'package:herbal/core/models/tips_model.dart';
import 'package:herbal/core/services/loading_manager.dart';
import 'package:herbal/view/screens/searchBar.dart';
import 'package:herbal/view/widgets/detail_tanaman.dart';
import 'package:herbal/view/widgets/detail_tipsSehat.dart';
import 'package:herbal/view/widgets/kategori.dart';
import 'package:herbal/view/widgets/layout/tanamanObat.dart';
import 'package:herbal/view/widgets/layout/tips_sehat.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  final int initialTab;

  const HomeScreen({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int jumlahKategori = 5;
  List<TanamanModel> _listTanaman = [];
  List<TipsModel> _listdataSehat = [];
  final TextEditingController searchController = TextEditingController();

  bool _isLoading = false; 

  Future<void> _fetchTanamanData() async {
    setState(() {
      _isLoading = true; 
    });
    try {
      List<TanamanModel> tanaman = await getTanaman();
      setState(() {
        _listTanaman = tanaman;
      });
    } catch (e) {
      print('Error fetching tanaman: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchTipsData() async {
    setState(() {
      _isLoading = true; 
    });
    try {
      List<TipsModel> tips = await getTips();
      setState(() {
        _listdataSehat = tips;
      });
    } catch (e) {
      print('Error fetching tips: $e');
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTanamanData();
    _fetchTipsData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: AnotherCarousel(
                        dotSize: 6.0,
                        dotSpacing: 15.0,
                        dotPosition: DotPosition.bottomCenter,
                        borderRadius: false,
                        dotBgColor: Colors.transparent,
                        images: [
                          Image.asset('assets/bannerr.jpg', fit: BoxFit.cover),
                          Image.asset('assets/bannere.jpg', fit: BoxFit.cover),
                          Image.asset('assets/bannerr.jpg', fit: BoxFit.cover),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ramuan Tradisional",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Kategori_Widgets(itemCount: jumlahKategori),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rekomendasi Tanaman Obat",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TanamanObat(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(6, 132, 0, 1),
                            ),
                            child: const Text("Lihat semua"),
                            
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            _listTanaman.length < 5 ? _listTanaman.length : 5,
                            (index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Detail_Tanaman(tanaman: _listTanaman[index]),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5), 
                                width: MediaQuery.of(context).size.width * 0.45, 
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
                                              image: NetworkImage(_listTanaman[index].gambar),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _listTanaman[index].nama_tanaman,
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
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tips Ringan Tentang Kesehatan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                          onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Tips_Sehat(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(6, 132, 0, 1),
                            ),
                            child: const Text("Lihat semua"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            _listdataSehat.length < 5 ? _listdataSehat.length : 5,
                            (index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Detail_Sehat(tipsKesehatan: _listdataSehat[index]),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                width: MediaQuery.of(context).size.width * 0.45,
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
                                              image: NetworkImage(_listdataSehat[index].gambar),
                                              fit: BoxFit.cover, 
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _listdataSehat[index].nama_tips,
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Search bar di atas carousel
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child:SearchBarWidget(controller: searchController),
            ),
          ],
        ),
      ),
    );
  }
}
