import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/API/rajaOngkirApi.dart';
import 'package:herbal/core/theme/app_colors.dart';

class TambahAlamatWidget extends StatefulWidget {
  @override
  State<TambahAlamatWidget> createState() => _TambahAlamatWidgetState();
}

class _TambahAlamatWidgetState extends State<TambahAlamatWidget> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kodePosController = TextEditingController();

  String? selectedProvinsi;
  String? selectedKota;

  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> cities = [];

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      final data = await fetchProvinces();
      setState(() {
        provinces = data;
      });
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  Future<void> _loadCities(String provinceId) async {
    try {
      final data = await fetchCities(provinceId);
      setState(() {
        cities = data;
        selectedKota = null; // Reset kota saat provinsi berubah
      });
    } catch (e) {
      print('Error fetching cities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
        title: const Text(
          "Alamat Baru",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Kontak"),
            _buildTextField("Nama Lengkap", namaController),
            _buildTextField("Nomor Telepon", teleponController,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 24),
            _buildSectionTitle("Alamat"),
            _buildTextField("Alamat Lengkap", alamatController),
            _buildDropdown(
              "Provinsi",
              selectedProvinsi,
              provinces.map((prov) {
                return DropdownMenuItem<String>(
                  value: prov['province_id'],
                  child: Text(prov['province']),
                );
              }).toList(),
              (value) {
                setState(() {
                  selectedProvinsi = value;
                });
                _loadCities(value!);
              },
            ),
            _buildDropdown(
              "Kabupaten/Kota",
              selectedKota,
              cities.map((city) {
                return DropdownMenuItem<String>(
                  value: city['city_id'],
                  child: Text(city['city_name']),
                );
              }).toList(),
              (value) {
                setState(() {
                  selectedKota = value;
                });
              },
            ),
            _buildTextField("Kode Pos", kodePosController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  // Aksi untuk menyimpan alamat
                  print('Alamat disimpan');
                },
                child: const Text(
                  "Simpan Alamat",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.lightPrimary,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.lightPrimary,
              width: 2.0,
            ),
          ),
        ),
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
