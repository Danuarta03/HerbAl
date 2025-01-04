import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/API/ramuanApi.dart';
import 'package:herbal/core/models/ramuan_model.dart';
import 'package:herbal/view/widgets/detail_ramuan.dart';

class RamuanTra extends StatefulWidget {
  final String id_kategori;
  final String nama_kategori;

  const RamuanTra({
    super.key,
    required this.id_kategori,
    required this.nama_kategori,
  });

  @override
  _RamuanTraState createState() => _RamuanTraState();
}

class _RamuanTraState extends State<RamuanTra> {
  late Future<List<RamuanModel>> _ramuanFuture;

  @override
  void initState() {
    super.initState();
    _ramuanFuture = getRamuanByKategori(widget.id_kategori);
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
        title: Text(
          widget.nama_kategori,
          style: const TextStyle(
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
          child: FutureBuilder<List<RamuanModel>>(
            future: _ramuanFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Tidak ada data ramuan untuk kategori ini.'),
                );
              } else {
                final filteredList = snapshot.data!
                    .where((ramuan) => ramuan.id_kategori == widget.id_kategori)
                    .toList();

                return RamuanGridView(
                  ramuanList: filteredList,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class RamuanGridView extends StatelessWidget {
  final List<RamuanModel> ramuanList;

  const RamuanGridView({
    super.key,
    required this.ramuanList,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1, 
      ),
      itemCount: ramuanList.length,
      itemBuilder: (context, index) {
        return RamuanCard(ramuan: ramuanList[index]);
      },
    );
  }
}

class RamuanCard extends StatelessWidget {
  final RamuanModel ramuan;

  const RamuanCard({
    super.key,
    required this.ramuan,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Detail_Ramuan(ramuan: ramuan),
          ),
        );
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bagian gambar
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                ramuan.gambar,
                height: 130, // Tinggi gambar
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // Nama ramuan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ramuan.nama_ramuan,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
