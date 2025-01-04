import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/API/penyakitApi.dart';
import 'package:herbal/core/models/penyakit_model.dart';
import 'package:herbal/view/widgets/detail_penyakit.dart';

class PenyakitRamuan extends StatefulWidget {
  const PenyakitRamuan({super.key});

  @override
  _PenyakitRamuanState createState() => _PenyakitRamuanState();
}

class _PenyakitRamuanState extends State<PenyakitRamuan> {
  late Future<List<PenyakitModel>> _penyakitFuture;

  @override
  void initState() {
    super.initState();
    _penyakitFuture = getPenyakit();
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
          "Penyakit dan Ramuannya",
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
          child: FutureBuilder<List<PenyakitModel>>(
            future: _penyakitFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data tanaman.'));
              } else {
                return PenyakitGridView(penyakitList: snapshot.data!);
              }
            },
          ),
        ),
      ),
    );
  }
}

class PenyakitGridView extends StatelessWidget {
  final List<PenyakitModel> penyakitList;

  const PenyakitGridView({super.key, required this.penyakitList});

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
      itemCount: penyakitList.length,
      itemBuilder: (context, index) => PenyakitCard(penyakit: penyakitList[index]),
    );
  }
}

class PenyakitCard extends StatelessWidget {
  final PenyakitModel penyakit;

  const PenyakitCard({super.key, required this.penyakit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail_Penyakit(penyakit: penyakit),
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
                    image: NetworkImage(penyakit.gambar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  penyakit.nama_penyakit,
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
