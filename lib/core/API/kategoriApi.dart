import 'dart:convert';
import 'package:herbal/core/models/kategori_model.dart';
import 'package:http/http.dart' as http;

// Base URL untuk API
const String baseUrl = 'http://192.168.0.102:8000';

// Endpoint untuk kategori
const String kategoriEndpoint = '$baseUrl/api/kategori';

// Base URL untuk gambar kategori
const String kategoriImageBaseUrl = '$baseUrl/storage/img/kategori';

// Fungsi untuk mengambil data kategori dari API
Future<List<KategoriModel>> getKategori() async {
  try {
    // Mengirim request GET ke API
    final response = await http.get(Uri.parse(kategoriEndpoint));

    // Memastikan response status code 200 (OK)
    if (response.statusCode == 200) {
      // Parsing response body yang berupa JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Mengakses properti 'data' yang berisi daftar kategori
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];

        // Mengembalikan list kategori yang sudah diparse ke objek KategoriModel
        return data.map((item) => KategoriModel.fromJson(item)).toList();
      } else {
        // Struktur JSON tidak sesuai
        throw Exception('Unexpected response structure: Missing "data" key');
      }
    } else {
      // Gagal mendapatkan response yang valid
      throw Exception('Failed to load categories. HTTP Status: ${response.statusCode}');
    }
  } catch (e) {
    // Log error untuk debugging
    print('Error fetching categories: $e');
    return []; // Kembalikan list kosong jika terjadi error
  }
}
