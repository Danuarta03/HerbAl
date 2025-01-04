import 'dart:convert';
import 'package:herbal/core/models/favorit_model.dart';
import 'package:http/http.dart' as http;

// Base URL untuk API
const String baseUrl = 'http://192.168.0.102:8000';

// Endpoint untuk favorit
const String favoritEndpoint = '$baseUrl/api/favorit';

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

class ApiServiceFavorit {
  /// Tambah data favorit (POST)
  Future<ApiResponse> tambahFavorit(FavoritModel favorit) async {
    final url = Uri.parse(favoritEndpoint);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': favorit.id,
          'id_ramuan': favorit.id_ramuan,
          'id_produk': favorit.id_produk,
          'id_tanaman': favorit.id_tanaman,
          'id_penyakit': favorit.id_penyakit,
          'id_tips': favorit.id_tips,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true) {
          return ApiResponse.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? 'Gagal menambahkan ke favorit.');
        }
      } else {
        throw Exception('Gagal menambahkan ke favorit: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat menambah ke favorit: $e');
    }
  }

  /// Ambil data favorit berdasarkan user (GET)
  Future<List<FavoritModel>> getFavorit(String id) async {
    try {
      final url = Uri.parse('$favoritEndpoint/$id');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => FavoritModel.fromJson(item)).toList();
        } else {
          final errorMessage = jsonResponse['message'] ?? 'Gagal memuat data favorit.';
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Failed to fetch favorit. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching favorit: $e');
      return [];
    }
  }

  /// Hapus data favorit (DELETE)
  Future<ApiResponse> deleteFavorit(String idFavorit) async {
    final url = Uri.parse('$favoritEndpoint/$idFavorit');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        throw Exception('Gagal menghapus data favorit: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat menghapus dari favorit: $e');
    }
  }

}


