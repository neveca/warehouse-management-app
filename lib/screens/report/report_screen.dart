import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/warehouse_service.dart';
import '../../api/stock_service.dart';
import '../../api/auth_provider.dart'; // Import the AuthProvider

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key}); // Removed token parameter

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<dynamic> warehouses = [];
  List<dynamic> stocks = [];
  int? selectedWarehouseId;
  String error = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWarehouses();
  }

  Future<void> fetchWarehouses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token; // Get token from provider

    if (token == null) {
      setState(() {
        error = 'No authentication token found';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      warehouses = await WarehouseService.getAllWarehouses(token); // Use token from provider
      if (warehouses.isNotEmpty) {
        selectedWarehouseId = warehouses[0]['warehouse_id'];
        await fetchStocks(selectedWarehouseId!);
      }
    } catch (e) {
      error = e.toString();
    }
    setState(() => isLoading = false);
  }

  Future<void> fetchStocks(int warehouseId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token; // Get token from provider

    if (token == null) {
      setState(() {
        error = 'No authentication token found';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      stocks = await StockService.getByWarehouse(token, warehouseId); // Use token from provider
    } catch (e) {
      error = e.toString();
    }
    setState(() => isLoading = false);
  }

  Widget _buildDropdown() {
    return DropdownButton<int>(
      value: selectedWarehouseId,
      items: warehouses
          .map(
            (w) => DropdownMenuItem<int>(
          value: w['warehouse_id'] as int,
          child: Text(w['warehouse_name']),
        ),
      )
          .toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() => selectedWarehouseId = val);
          fetchStocks(val);
        }
      },
      isExpanded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Report")),
        body: Center(child: Text('Error: $error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouse Stock Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (warehouses.isNotEmpty) ...[
              _buildDropdown(),
              const SizedBox(height: 16),
            ],
            stocks.isEmpty
                ? const Center(child: Text("No stocks in this warehouse."))
                : Expanded(
              child: ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text("Item ID: ${stock['item_id']}"),
                      subtitle: Text(
                        "Quantity: ${stock['quantity']}\nLast Updated: ${stock['last_updated'] ?? ''}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}