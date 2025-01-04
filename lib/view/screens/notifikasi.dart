import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/theme/app_colors.dart'; 

class Notifikasi extends StatefulWidget {
  const Notifikasi({Key? key}) : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkScaffoldColor : AppColors.lightScaffoldColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
        title: Text(
          "Notifikasi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.chevron_left, color: Colors.white),
        ),
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Icon(
                CupertinoIcons.bell_fill,
                size: 100,
                color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
            Text(
              "Belum ada notifikasi",
              style: TextStyle(
                color: isDarkMode ? AppColors.darkTextColor : Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
