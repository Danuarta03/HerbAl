import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:herbal/core/models/kategori_model.dart';
import 'package:herbal/core/models/ramuan_model.dart';

// Base URL untuk API
const String baseUrl = 'http://192.168.0.102:8000';

// Endpoint untuk kategori dan ramuan
const String kategoriEndpoint = '$baseUrl/api/kategori';
const String ramuanEndpoint = '$baseUrl/api/ramuan';

// Base URL untuk gambar
const String ramuanImageBaseUrl = '$baseUrl/storage/img/ramuan';

// Fungsi untuk mengambil semua kategori dari API
Future<List<KategoriModel>> getKategori() async {
  try {
    // Mengirim request GET ke endpoint kategori
    final response = await http.get(Uri.parse(kategoriEndpoint));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => KategoriModel.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response structure: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load categories. HTTP Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching categories: $e');
    return [];
  }
}

// Fungsi untuk mengambil data ramuan berdasarkan id_kategori
Future<List<RamuanModel>> getRamuanByKategori(String id_kategori) async {
  try {
    // URL dengan query parameter id_kategori
    final String url = '$ramuanEndpoint?id_kategori=$id_kategori';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => RamuanModel.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response structure: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data. HTTP Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data by kategori: $e');
    return [];
  }
}

// Fungsi untuk mengambil semua ramuan tanpa filter kategori (opsional)
Future<List<RamuanModel>> getRamuan() async {
  try {
    // Mengirim request GET ke endpoint ramuan
    final response = await http.get(Uri.parse(ramuanEndpoint));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => RamuanModel.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response structure: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load ramuan. HTTP Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching ramuan: $e');
    return [];
  }
}
