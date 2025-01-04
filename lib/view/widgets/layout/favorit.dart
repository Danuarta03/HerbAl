import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/API/favoritApi.dart';
import 'package:herbal/core/models/favorit_model.dart';
import 'package:herbal/core/utility/SharedPreferences.dart';
import 'package:herbal/view/widgets/detail_penyakit.dart';
import 'package:herbal/view/widgets/detail_ramuan.dart';
import 'package:herbal/view/widgets/detail_tanaman.dart';
import 'package:herbal/view/widgets/detail_tipsSehat.dart';

class FavoritScreen extends StatefulWidget {
  final String idUser;
  const FavoritScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  State<FavoritScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  final ApiServiceFavorit _apiService = ApiServiceFavorit();
  late Future<List<FavoritModel>> _favoritesFuture = Future.value([]);
  String? userId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _loadUserId();
      if (userId != null) {
        await _tampilFavorit();
      } else {
        setState(() {
          _favoritesFuture = Future.value([]);
        });
      }
    } catch (e) {
      print("Error initializing data: $e");
      setState(() {
        _favoritesFuture = Future.value([]);
      });
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

  Future<void> _tampilFavorit() async {
    try {
      final List<FavoritModel> favorites = await _apiService.getFavorit(userId!);
      setState(() {
        _favoritesFuture = Future.value(favorites);
      });
    } catch (e) {
      print('Error fetching favorit: $e');
      setState(() {
        _favoritesFuture = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_back, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(6, 132, 0, 1),
        title: const Text(
          "Favorit",
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
          child: FutureBuilder<List<FavoritModel>>(
            future: _favoritesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Favorit Kosong.'));
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final favorit = snapshot.data![index];
                    return FavoritItemWidget(favorit: favorit);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}


class FavoritItemWidget extends StatelessWidget {
  final FavoritModel favorit;

  const FavoritItemWidget({Key? key, required this.favorit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String namaFavorit = '';
    String gambarFavorit = '';

    if (favorit.tanaman != null) {
      namaFavorit = favorit.tanaman?.nama_tanaman ?? 'Nama tidak tersedia';
      gambarFavorit = favorit.tanaman?.gambar ?? '';
    } else if (favorit.ramuan != null) {
      namaFavorit = favorit.ramuan?.nama_ramuan ?? 'Nama tidak tersedia';
      gambarFavorit = favorit.ramuan?.gambar ?? '';
    } else if (favorit.penyakit != null) {
      namaFavorit = favorit.penyakit?.nama_penyakit ?? 'Nama tidak tersedia';
      gambarFavorit = favorit.penyakit?.gambar ?? '';
    } else if (favorit.tips != null) {
      namaFavorit = favorit.tips?.nama_tips ?? 'Nama tidak tersedia';
      gambarFavorit = favorit.tips?.gambar ?? '';
    }

    return GestureDetector(
      onTap: () {
        if (favorit.tanaman != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=> Detail_Tanaman(tanaman : favorit.tanaman!),
            ),
          );
        } else if (favorit.ramuan != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=> Detail_Ramuan(ramuan: favorit.ramuan!),
            ),
          );
        } else if (favorit.penyakit != null) {
          Navigator.push(
            context,
          MaterialPageRoute(
            builder: (context)=> Detail_Penyakit(penyakit : favorit.penyakit!),
          ),
          );
        } else if (favorit.tips != null) {
          Navigator.push(
            context,
          MaterialPageRoute(
            builder: (context)=> Detail_Sehat(tipsKesehatan : favorit.tips!),
          ),
          );
        }
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(gambarFavorit),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        namaFavorit,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    // Tambahkan fungsi hapus dari favorit jika diperlukan
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
