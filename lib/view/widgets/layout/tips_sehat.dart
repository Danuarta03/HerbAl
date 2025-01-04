import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/API/tipsApi.dart';
import 'package:herbal/core/models/tips_model.dart';
import 'package:herbal/view/widgets/detail_tipsSehat.dart';

class Tips_Sehat extends StatefulWidget {
  const Tips_Sehat({super.key});

  @override
  _Tips_SehatState createState() => _Tips_SehatState();
}

class _Tips_SehatState extends State<Tips_Sehat> {
  late Future<List<TipsModel>> _tipsFuture;

  @override
  void initState() {
    super.initState();
    _tipsFuture = getTips();
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
          "Tips Ringan Tentang Kesehatan",
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                FutureBuilder<List<TipsModel>>(
                  future: _tipsFuture, 
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data tips.'));
                    } else {
                      List<TipsModel> tipsKesehatanList = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) => Tampil_tipsSehat(
                          listdataSehat: tipsKesehatanList[index],
                        ),
                        itemCount: tipsKesehatanList.length,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tampil_tipsSehat extends StatelessWidget {
  final TipsModel listdataSehat;
  const Tampil_tipsSehat({super.key, required this.listdataSehat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail_Sehat(tipsKesehatan: listdataSehat),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(listdataSehat.gambar), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    listdataSehat.nama_tips,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
