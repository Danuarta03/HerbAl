import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:herbal/core/API/keranjangApi.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/models/keranjang_model.dart';
import 'package:herbal/core/services/loading_manager.dart';
import 'package:herbal/root_screen.dart';
import 'package:herbal/view/screens/auth/welcome.dart';
import 'package:herbal/view/screens/cart/detail_pesanan.dart';
import 'package:intl/intl.dart';

class Keranjang extends StatefulWidget {
  final String? id;

  const Keranjang({Key? key, this.id}) : super(key: key);

  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  final ApiServiceKeranjang _apiService = ApiServiceKeranjang();
  List<KeranjangModel> keranjangList = [];
  bool isLoading = true;
  String? errorMessage;
  Map<int, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _fetchKeranjangData();
  }

  Future<void> _fetchKeranjangData() async {
    if (widget.id == null || widget.id!.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = "Anda belum login. Silakan login untuk melihat keranjang Anda.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getKeranjang(widget.id!);
      setState(() {
        keranjangList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Gagal memuat data keranjang. ${e.toString()}";
      });
    }
  }

  Future<void> _updateJumlahProduk(int idKeranjang, int jumlahBaru) async {
    try {
      await _apiService.updateKeranjang(idKeranjang: idKeranjang, jumlah: jumlahBaru);
      _fetchKeranjangData(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui jumlah produk: ${e.toString()}")),
      );
    }
  }

  double _calculateTotal() {
    double total = 0;
    for (var keranjang in keranjangList) {
      if (selectedItems[keranjang.id_keranjang] ?? false) {
       total += double.parse(keranjang.produk.harga.toString()) * keranjang.jumlah;

      }
    }
    return total;
  }

  // Fungsi untuk memformat angka menjadi Rupiah
    String formatRupiah(int number) {
      final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
      return formatter.format(number);
    }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LoadingManager(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppColors.darkScaffoldColor : Colors.grey[200],
        appBar: AppBar(
          backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
          title: const Text(
            "Keranjang",
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
          toolbarHeight: 80,
        ),
        body: keranjangList.isEmpty
            ? _buildKeranjangKosong(isDarkMode)
            : _buildKeranjangAdaData(isDarkMode),
        bottomNavigationBar: keranjangList.isEmpty ? null : _buildBottomNavigationBar(isDarkMode),
      ),
    );
  }

  Widget _buildKeranjangKosong(bool isDarkMode) {
    final isUserNotLoggedIn = widget.id == null || widget.id!.isEmpty;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cart.png',
              height: 400,
              color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
            const SizedBox(height: 20),
            Text(
              "Keranjang belanja Anda masih kosong.",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (isUserNotLoggedIn) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>RootScreen()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
              child: Text(
                isUserNotLoggedIn ? "Ayo Login" : "Mulai Belanja",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeranjangAdaData(bool isDarkMode) {
  return ListView.builder(
    itemCount: keranjangList.length,
    itemBuilder: (context, index) {
      final keranjang = keranjangList[index];
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: selectedItems[keranjang.id_keranjang] ?? false,
                activeColor: const Color.fromRGBO(6, 132, 0, 1), // Warna hijau
                onChanged: (value) {
                  setState(() {
                    selectedItems[keranjang.id_keranjang] = value!;
                  });
                },
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    keranjang.produk.gambar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      keranjang.produk.nama_produk,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formatRupiah(int.tryParse(keranjang.produk.harga) ?? 0), // Konversi ke int
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        await _apiService.deleteKeranjang(keranjang.id_keranjang);
                        _fetchKeranjangData();
                        Fluttertoast.showToast(
                          msg: "Produk berhasil dihapus",
                          backgroundColor: Color.fromRGBO(6, 132, 0, 1),
                          textColor: Colors.white,
                        );
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: "Gagal menghapus produk: ${e.toString()}",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (keranjang.jumlah > 1) {
                              _updateJumlahProduk(keranjang.id_keranjang, keranjang.jumlah - 1);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Jumlah tidak boleh kurang dari 1",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                          child: const Icon(
                            Icons.remove,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${keranjang.jumlah}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            _updateJumlahProduk(keranjang.id_keranjang, keranjang.jumlah + 1);
                          },
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


  Widget _buildBottomNavigationBar(bool isDarkMode) {
    return Container(
      height: 70,
      color: isDarkMode ? AppColors.darkCardColor : Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      color: Color.fromRGBO(6, 132, 0, 1), 
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(_calculateTotal().toInt()),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                  // Filter data produk yang dipilih
                  final selectedProduk = keranjangList
                      .where((item) => selectedItems[item.id_keranjang] ?? false)
                      .map((item) => {
                            'nama_produk': item.produk.nama_produk ?? 'Nama tidak tersedia',
                            'jumlah': item.jumlah ?? 0,
                            'harga': item.produk.harga ?? 0,
                            'gambar': item.produk.gambar ?? '',
                          })
                      .toList();

                  // Hitung jumlah item yang dipilih
                  final totalItems = selectedProduk.fold<int>(
                    0,
                    (sum, item) => sum + (item['jumlah'] as int),
                  );

                  // Log data untuk debugging
                  print('Selected Produk: $selectedProduk');
                  print('Total Harga: ${_calculateTotal().toInt()}');
                  print('Total Items: $totalItems');
                  print('Metode Pembayaran: Transfer Bank');

                  // Navigasi ke layar DetailPesanan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPesanan(
                        selectedProduk: selectedProduk,
                        totalHarga: _calculateTotal().toInt(),
                        totalItems: totalItems,
                        metodePembayaran: "Transfer Bank",
                      ),
                    ),
                  );
                },

              child: Container(
                color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                child: const Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}