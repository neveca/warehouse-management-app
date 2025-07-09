import 'dart:convert';
import 'api_service.dart';

class StockService {
  static Future<List<dynamic>> getByWarehouse(String token, int warehouseId) async {
    final response = await ApiService.get('/stocks/warehouse/$warehouseId', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch stocks');
  }

  static Future<List<dynamic>> getByItem(String token, int itemId) async {
    final response = await ApiService.get('/stocks/item/$itemId', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch stocks');
  }

  static Future<bool> upsertStock(String token, Map<String, dynamic> stock) async {
    final response = await ApiService.post('/stocks/', body: stock, token: token);
    return response.statusCode == 201;
  }

  static Future<bool> deleteByItemAndWarehouse(String token, int itemId, int warehouseId) async {
    final response = await ApiService.delete('/stocks/item/$itemId/warehouse/$warehouseId', token: token);
    return response.statusCode == 200;
  }
}