import 'dart:convert';
import 'package:herbal/core/models/tanaman_model.dart';
import 'package:http/http.dart' as http;

// Base URL untuk API
const String baseUrl = 'http://192.168.0.102:8000';

// Endpoint untuk tanaman
const String tanamanEndpoint = '$baseUrl/api/tanaman';

// Base URL untuk gambar  tanaman
const String tanamanImageBaseUrl = '$baseUrl/storage/img/tanaman_obat';

// Fungsi untuk mengambil data  dari API
Future<List<TanamanModel>> getTanaman() async {
  try {
    // Mengirim request GET ke API
    final response = await http.get(Uri.parse(tanamanEndpoint));

    // Memastikan response status code 200 (OK)
    if (response.statusCode == 200) {
      // Parsing response body yang berupa JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Mengakses properti 'data' yang berisi daftar tanaman
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];

        // Mengembalikan list kategori yang sudah diparse ke objek TanaanModel
        return data.map((item) => TanamanModel.fromJson(item)).toList();
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
