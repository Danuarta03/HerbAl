import 'dart:convert';
import 'package:herbal/core/models/tips_model.dart';
import 'package:http/http.dart' as http;

// Base URL untuk API
const String baseUrl = 'http://192.168.0.102:8000';

// Endpoint untuk mendapatkan data tips
const String tipsEndpoint = '$baseUrl/api/tips';

// Base URL untuk gambar
const String tipsImageBaseUrl = '$baseUrl/storage/img/tips';

// Fungsi untuk mengambil data dari API
Future<List<TipsModel>> getTips() async {
  try {
    // Mengirim request GET ke API
    final response = await http.get(Uri.parse(tipsEndpoint));

    // Memastikan response status code 200 (OK)
    if (response.statusCode == 200) {
      // Parsing response body yang berupa JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Mengakses properti 'data' yang berisi daftar tips
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];

        // Mengembalikan list TipsModel yang sudah diparse
        return data.map((item) => TipsModel.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response structure: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load tips. HTTP Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching tips: $e');
    return []; // Mengembalikan list kosong jika terjadi error
  }
}
