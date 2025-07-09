import 'dart:convert';
import 'api_service.dart';

class WarehouseService {
  static Future<List<dynamic>> getAllWarehouses(String token) async {
    final response = await ApiService.get('/warehouses/', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch warehouses');
  }

  static Future<Map<String, dynamic>> getWarehouseById(String token, int id) async {
    final response = await ApiService.get('/warehouses/$id', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch warehouse');
  }

  static Future<bool> createWarehouse(String token, Map<String, dynamic> warehouse) async {
    final response = await ApiService.post('/warehouses/', body: warehouse, token: token);
    return response.statusCode == 201;
  }

  static Future<bool> updateWarehouse(String token, int id, Map<String, dynamic> warehouse) async {
    final response = await ApiService.put('/warehouses/$id', body: warehouse, token: token);
    return response.statusCode == 200;
  }

  static Future<bool> deleteWarehouse(String token, int id) async {
    final response = await ApiService.delete('/warehouses/$id', token: token);
    return response.statusCode == 200;
  }
}