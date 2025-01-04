import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/view/screens/cart/tambah_alamat.dart';
import 'package:intl/intl.dart';

class AlamatWidget extends StatefulWidget {
  @override
  State<AlamatWidget> createState() => _AlamatWidgetState();
}

class _AlamatWidgetState extends State<AlamatWidget> {
  String? selectedAddress;
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
          "Alamat",
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
                  const Text(
                    "Pilih atau tambahkan alamat pengiriman",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildAddressOption(
                    "I Kadek Diwa Anjapuryana (082144535209)",
                    "Jalan Sudirman, nomor 46, Singaraja",
                  ),
                  _buildAddressOption(
                    "Anjapuryana (082144535209)",
                    "Jalan Sudirman, nomor 46, Singaraja",
                  ),
                  _buildAddressOption(
                    "Kadek (082144535209)",
                    "Jalan Sudirman, nomor 46, Singaraja",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TambahAlamatWidget()),
                      );
                    },
                    child: const Center(
                      child: Text(
                        "Tambah Alamat",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
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

  Widget _buildAddressOption(String name, String address) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddress = name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedAddress == name ? Colors.green.shade50 : Colors.white,
          border: Border.all(
            color: selectedAddress == name
                ? AppColors.lightPrimary
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: name,
              groupValue: selectedAddress,
              onChanged: (value) {
                setState(() {
                  selectedAddress = value;
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
            onPressed: () {
              // Aksi untuk melanjutkan
            },
            child: const Text(
              "Lanjutkan",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
