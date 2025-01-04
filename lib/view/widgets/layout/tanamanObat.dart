import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/API/tanamanApi.dart';
import 'package:herbal/core/models/tanaman_model.dart';
import 'package:herbal/view/widgets/detail_tanaman.dart';

class TanamanObat extends StatefulWidget {
  const TanamanObat({super.key});

  @override
  _TanamanObatState createState() => _TanamanObatState();
}

class _TanamanObatState extends State<TanamanObat> {
  late Future<List<TanamanModel>> _tanamanObatFuture;

  @override
  void initState() {
    super.initState();
    _tanamanObatFuture = getTanaman();
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
          "Tanaman Obat",
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
          child: FutureBuilder<List<TanamanModel>>(
            future: _tanamanObatFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data tanaman.'));
              } else {
                return TanamanGridView(tanamanList: snapshot.data!);
              }
            },
          ),
        ),
      ),
    );
  }
}

class TanamanGridView extends StatelessWidget {
  final List<TanamanModel> tanamanList;

  const TanamanGridView({super.key, required this.tanamanList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemCount: tanamanList.length,
      itemBuilder: (context, index) => TanamanCard(tanaman: tanamanList[index]),
    );
  }
}

class TanamanCard extends StatelessWidget {
  final TanamanModel tanaman;

  const TanamanCard({super.key, required this.tanaman});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail_Tanaman(tanaman: tanaman),
        ),
      ),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(tanaman.gambar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  tanaman.nama_tanaman,
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
    );
  }
}
