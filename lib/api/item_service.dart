import 'dart:convert';
import 'api_service.dart';

class ItemService {
  static Future<List<dynamic>> getAllItems(String token) async {
    final response = await ApiService.get('/items/', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch items');
  }

  static Future<Map<String, dynamic>> getItemById(String token, int id) async {
    final response = await ApiService.get('/items/$id', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch item');
  }

  static Future<bool> createItem(String token, Map<String, dynamic> item) async {
    final response = await ApiService.post('/items/', body: item, token: token);
    return response.statusCode == 201;
  }

  static Future<bool> updateItem(String token, int id, Map<String, dynamic> item) async {
    final response = await ApiService.put('/items/$id', body: item, token: token);
    return response.statusCode == 200;
  }

  static Future<bool> deleteItem(String token, int id) async {
    final response = await ApiService.delete('/items/$id', token: token);
    return response.statusCode == 200;
  }
}