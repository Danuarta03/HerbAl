import 'dart:convert';
import 'package:herbal/core/models/keranjang_model.dart';
import 'package:http/http.dart' as http;

// Base URL untuk API
const String baseUrl = 'http://192.168.0.102:8000';

// Endpoint untuk keranjang
const String keranjangEndpoint = '$baseUrl/api/keranjang';

class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;

  ApiResponse({required this.success, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
    );
  }
}

class ApiServiceKeranjang {
  /// Tambah produk ke keranjang (POST)
  Future<ApiResponse> tambahKeKeranjang(KeranjangModel keranjang) async {
    final url = Uri.parse(keranjangEndpoint);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': keranjang.idUser,
          'id_produk': keranjang.idProduk,
          'jumlah': keranjang.jumlah,
        }),
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true) {
          return ApiResponse.fromJson(responseData); 
        } else {
          throw Exception(responseData['message'] ?? 'Gagal menambahkan item ke keranjang.');
        }
      } else {
        throw Exception('Gagal menambahkan item ke keranjang: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat menambah ke keranjang: $e');
    }
  }

  /// Ambil data keranjang (GET)
    Future<List<KeranjangModel>> getKeranjang(String id) async {
      try {
        // Membuat URL endpoint dengan userId sebagai parameter
        final url = Uri.parse('$keranjangEndpoint/user/$id');

        // Mengirim request GET ke API
        final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse['success'] == true) {
            final List<dynamic> data = jsonResponse['data'];

            // Mengonversi JSON ke list model
            return data.map((item) => KeranjangModel.fromJson(item)).toList();
          } else {
            // API mengembalikan status gagal
            final errorMessage = jsonResponse['message'] ?? 'Gagal memuat data keranjang.';
            throw Exception(errorMessage);
          }
        } else {
          // Status kode HTTP bukan 200
          throw Exception('Failed to fetch keranjang. HTTP Status: ${response.statusCode}');
        }
      } catch (e) {
        // Log error untuk debugging
        print('Error fetching keranjang: $e');
        return []; // Mengembalikan list kosong jika terjadi error
      }
    }

  /// Perbarui jumlah produk di keranjang (PUT)
  Future<ApiResponse> updateKeranjang({
    required int idKeranjang,
    required int jumlah,
  }) async {
    final url = Uri.parse('$keranjangEndpoint/$idKeranjang');
    try {
      // Kirim request PUT ke API
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jumlah': jumlah,
        }),
      );

      // Tangani respons API
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Cek apakah respons sukses
        if (data['success'] == true) {
          return ApiResponse.fromJson(data); // Kembalikan respons sukses
        } else {
          throw Exception(data['message'] ?? 'Gagal memperbarui keranjang.');
        }
      } else {
        throw Exception('Gagal memperbarui keranjang. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat memperbarui keranjang: $e');
    }
  }

  /// Hapus produk dari keranjang (DELETE)
  Future<ApiResponse> deleteKeranjang(int id_keranjang) async {
    final url = Uri.parse('$keranjangEndpoint/$id_keranjang');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        throw Exception('Gagal menghapus item dari keranjang: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat menghapus dari keranjang: $e');
    }
  }
}
