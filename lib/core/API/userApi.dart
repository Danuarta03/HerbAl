import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String baseUrlS = 'http://192.168.0.102:8000/api/user';

class APIResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  APIResponse({required this.success, this.data, this.message});

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    return APIResponse(
      success: json['success'] ?? false,
      data: json['data'],
      message: json['message'],
    );
  }
}

// Fungsi untuk login atau mendaftarkan user berdasarkan UID
Future<APIResponse<Map<String, dynamic>>> sendUIDToAPI(
  String uid, {
  String? name,
  String? email,
}) async {
  final String url = '$baseUrlS/login-with-uid';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uid': uid,
        'name': name ?? 'Anonymous User',
        'email': email ?? 'no_email_provided@example.com',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Simpan ID pengguna di Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      final id = data['data']['user']['id']; // Pastikan struktur JSON benar
      await prefs.setString('id', id.toString());

      return APIResponse.fromJson(data);
    } else {
      return APIResponse(
        success: false,
        message: 'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  } catch (e) {
    return APIResponse(
      success: false,
      message: 'Error while sending UID to API: $e',
    );
  }
}


// Fungsi untuk mengambil data user berdasarkan ID
Future<APIResponse<Map<String, dynamic>>> fetchUserDataFromAPI(String id) async {
  final String url = '$baseUrlS/$id';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_api_token', 
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return APIResponse.fromJson(data);
    } else {
      return APIResponse(
        success: false,
        message: 'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  } catch (e) {
    return APIResponse(
      success: false,
      message: 'Error fetching user data: $e',
    );
  }
}
