import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/view/screens/cart/alamat.dart';
import 'package:herbal/view/screens/cart/pembayaran.dart';
import 'package:intl/intl.dart';

class DetailPesanan extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProduk;
  final int totalHarga;
  final int totalItems;
  final String metodePembayaran;

  const DetailPesanan({
    Key? key,
    required this.selectedProduk,
    required this.totalHarga,
    required this.totalItems,
    required this.metodePembayaran,
  }) : super(key: key);

  @override
  State<DetailPesanan> createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  late String _selectedMetodePengiriman;
  late int _selectedBiayaPengiriman;

  @override
  void initState() {
    super.initState();
    _selectedMetodePengiriman = "REG - Reguler";
    _selectedBiayaPengiriman = 16000;
  }

  String formatRupiah(int number) {
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      int totalPesanan = widget.totalHarga + _selectedBiayaPengiriman;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:
              const Icon(CupertinoIcons.chevron_left, color: Colors.white),
        ),
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTambahAlamat(isDarkMode),
            const Divider(),
            _buildItemProduk(),
            const SizedBox(height: 20),
            _buildOpsiPengiriman(),
            const Divider(),
            _buildMetodePembayaran(),
            const Divider(),
            _buildSubtotal(totalPesanan),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
          isDarkMode, totalPesanan),
    );
  }

  Widget _buildTambahAlamat(bool isDarkMode) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: AppColors.lightPrimary),
      title: const Text("Tambah Alamat Pengiriman"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AlamatWidget()),
        );
      },
    );
  }

  Widget _buildItemProduk() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Produk yang Dipilih",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.selectedProduk.length,
          itemBuilder: (context, index) {
            final product = widget.selectedProduk[index];
            return ListTile(
              leading: Image.network(product['gambarProduk'], width: 50),
              title: Text(product['namaProduk']),
              subtitle: Text(
                "${formatRupiah(product['hargaProduk'])} x ${product['jumlahProduk']}",
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOpsiPengiriman() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Opsi Pengiriman",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showOpsiPengiriman(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedMetodePengiriman),
              Row(
                children: [
                  Text(formatRupiah(_selectedBiayaPengiriman)),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

Widget _buildMetodePembayaran() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Metode Pembayaran",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PembayaranWidget()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.metodePembayaran),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildSubtotal(int totalPesanan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rincian Pembayaran",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Subtotal untuk produk"),
            Text(formatRupiah(widget.totalHarga)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Subtotal pengiriman"),
            Text(formatRupiah(_selectedBiayaPengiriman)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              formatRupiah(totalPesanan),
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(
      bool isDarkMode, int totalPesanan) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCardColor : Colors.white,
        border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total Pembayaran",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.lightPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(totalPesanan),
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
                // Aksi untuk membuat pesanan
              },
              child: Container(
                color: isDarkMode
                    ? AppColors.darkPrimary
                    : AppColors.lightPrimary,
                child: const Center(
                  child: Text(
                    "Buat Pesanan",
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

  void _showOpsiPengiriman(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Metode Pengiriman",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text(
                    "OKE - Ongkos Kirim Ekonomis (IDR 14.000)"),
                subtitle: const Text("Estimasi 3-4 hari"),
                onTap: () {
                  setState(() {
                    _selectedMetodePengiriman = "OKE - Ekonomis";
                    _selectedBiayaPengiriman = 14000;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("REG - Layanan Reguler (IDR 16.000)"),
                subtitle: const Text("Estimasi 2-3 hari"),
                onTap: () {
                  setState(() {
                    _selectedMetodePengiriman = "REG - Reguler";
                    _selectedBiayaPengiriman = 16000;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
