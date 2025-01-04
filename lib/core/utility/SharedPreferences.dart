import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  /// Simpan ID pengguna ke Shared Preferences
  static Future<void> saveUserIdFromAPIResponse(Map<String, dynamic> apiResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Validasi struktur data API response
      if (apiResponse['data'] != null &&
          apiResponse['data']['user'] != null &&
          apiResponse['data']['user']['id'] != null) {
        String userId = apiResponse['data']['user']['id'].toString();
        await prefs.setString('id', userId);
        print('ID berhasil disimpan: $userId');
      } else {
        print('Struktur API response tidak valid. Field "data.user.id" tidak ditemukan.');
      }
    } catch (e) {
      print('Terjadi kesalahan saat menyimpan ID: $e');
    }
  }

  /// Mendapatkan ID pengguna dari Shared Preferences
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? userId = prefs.getString('id'); 
      if (userId != null) {
        print('ID ditemukan di Shared Preferences: $userId');
      } else {
        print('ID tidak ditemukan di Shared Preferences.');
      }
      return userId;
    } catch (e) {
      print('Terjadi kesalahan saat mengambil ID: $e');
      return null;
    }
  }

  /// Hapus semua data pengguna dari Shared Preferences
  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.clear(); 
      print('Semua data berhasil dihapus dari Shared Preferences.');
    } catch (e) {
      print('Terjadi kesalahan saat menghapus data: $e');
    }
  }
}
