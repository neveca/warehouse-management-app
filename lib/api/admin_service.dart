import 'dart:convert';
import 'api_service.dart';

class AdminService {
  static Future<Map<String, dynamic>?> getAdminByUsername(String token, String username) async {
    final response = await ApiService.get('/admins/$username', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<bool> createAdmin(String token, Map<String, dynamic> admin) async {
    final response = await ApiService.post('/admins', body: admin, token: token);
    return response.statusCode == 201;
  }
}