import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class PembayaranWidget extends StatefulWidget {
  @override
  State<PembayaranWidget> createState() => _PembayaranWidgetState();
}

class _PembayaranWidgetState extends State<PembayaranWidget> {
  String? selectedPaymentMethod;
  final int totalBelanja = 20000; // Contoh total belanja

  String formatRupiah(int number) {
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
        title: const Text(
          "Pembayaran",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.chevron_left, color: Colors.white),
        ),
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Metode Pembayaran",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aksi untuk melihat semua metode pembayaran
                        },
                        child: const Text(
                          "Lihat semua",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentOption(
                    "BRI Virtual Account",
                    "BRIVA",
                    "assets/BCA.jpg", 
                    // child: Image.asset(
                    //     'assets/BRI.jpg',
                    //     width: 24,
                    //     height: 24,
                    //   ),
                  ),
                  _buildPaymentOption(
                    "BCA Virtual Account",
                    "BCA VA",
                    "assets/BCA.jpg", // Ganti dengan path logo BCA
                  ),
                ],
              ),
            ),
          ),
          _buildBottomNavigationBar(isDarkMode, totalBelanja),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String name, String code, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = code;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              selectedPaymentMethod == code ? Colors.green.shade50 : Colors.white,
          border: Border.all(
            color: selectedPaymentMethod == code
                ? AppColors.lightPrimary
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Radio<String>(
              value: code,
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
              activeColor: AppColors.lightPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isDarkMode, int totalPesanan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCardColor : Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Belanja",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                formatRupiah(totalPesanan),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: selectedPaymentMethod != null
                ? () {
                    // Aksi untuk konfirmasi pembayaran
                  }
                : null,
            child: const Text(
              "Konfirmasi",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
