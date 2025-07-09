import 'dart:convert';
import 'api_service.dart';

class AuthService {
  // Login, returns JWT token if success
  static Future<String?> login(String username, String password) async {
    final response = await ApiService.post(
      '/login',
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      return null;
    }
  }
}