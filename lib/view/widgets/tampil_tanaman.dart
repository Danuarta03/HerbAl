import 'package:flutter/material.dart';
import 'package:herbal/core/models/tanaman_model.dart';
import 'package:herbal/view/widgets/detail_tanaman.dart';
import 'package:iconsax/iconsax.dart';


class View_tanaman extends StatelessWidget {
  final TanamanModel tanaman;
  const View_tanaman({super.key, required this.tanaman});

  @override
  Widget build(BuildContext context) {
  return GestureDetector(
    onTap: ()=> Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> Detail_Tanaman(tanaman : tanaman),
      ),
    ),
    child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(tanaman.gambar),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      tanaman.nama_tanaman,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: IconButton(
                    onPressed: (){},
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                    fixedSize: Size(40, 40),
                    ),
                    iconSize:20,
                    icon: const Icon(Iconsax.star),
                  ),
                ),
              ],
            )
          ),
  );
  }
}