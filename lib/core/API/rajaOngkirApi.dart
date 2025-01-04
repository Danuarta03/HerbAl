import 'dart:convert';
import 'package:http/http.dart' as http;

// API Key RajaOngkir
const String rajaOngkirApiKey = 'cINhOZ4cd423cf49a3ed5783MplGOrRU';
const String rajaOngkirBaseUrl = 'https://api.rajaongkir.com/starter';

// Fungsi untuk mengambil daftar provinsi
Future<List<Map<String, dynamic>>> fetchProvinces() async {
  final response = await http.get(
    Uri.parse('$rajaOngkirBaseUrl/province'),
    headers: {'key': rajaOngkirApiKey},
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return List<Map<String, dynamic>>.from(jsonResponse['rajaongkir']['results']);
  } else {
    throw Exception('Failed to load provinces');
  }
}

// Fungsi untuk mengambil daftar kota berdasarkan ID provinsi
Future<List<Map<String, dynamic>>> fetchCities(String provinceId) async {
  final response = await http.get(
    Uri.parse('$rajaOngkirBaseUrl/city?province=$provinceId'),
    headers: {'key': rajaOngkirApiKey},
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return List<Map<String, dynamic>>.from(jsonResponse['rajaongkir']['results']);
  } else {
    throw Exception('Failed to load cities');
  }
}
