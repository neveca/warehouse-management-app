import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/warehouse_service.dart';
import '../../api/item_service.dart';
import '../../api/stock_service.dart';
import '../../api/auth_provider.dart';
import '../stock_in/stock_in_screen.dart';
import 'widgets/action_button.dart';
import 'widgets/capacity_status_card.dart';
import '../stock_out/stock_out_screen.dart';
import '../report/report_screen.dart';

import 'widgets/transaction_summary.dart';
import 'widgets/stock_quantity_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});  // Removed token parameter

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<dynamic> warehouses = [];
  List<dynamic> items = [];
  List<dynamic> stocks = [];
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;  // Get token from provider

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
      warehouses = await WarehouseService.getAllWarehouses(token);
      items = await ItemService.getAllItems(token);

      if (warehouses.isNotEmpty) {
        stocks = await StockService.getByWarehouse(token, warehouses[0]['warehouse_id']);
      }
    } catch (e) {
      error = e.toString();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchAllData,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                warehouses.isNotEmpty
                    ? warehouses[0]['warehouse_name']
                    : "No Warehouse",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "What are you looking for?",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              const Text("What do you want to do?", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionButton(
                    icon: Icons.download,
                    label: 'Stock in',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StockInScreen(),  // Removed token
                        ),
                      );
                    },
                  ),
                  ActionButton(
                    icon: Icons.upload,
                    label: 'Stock out',
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StockOutScreen(),  // Removed token
                        ),
                      );
                    },
                  ),
                  ActionButton(
                    icon: Icons.bar_chart,
                    label: 'Report',
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportScreen(),  // Removed token
                        ),
                      );
                    },
                  ),
                  const ActionButton(icon: Icons.file_copy, label: 'Export', color: Colors.blue),
                ],
              ),
              const SizedBox(height: 32),
              Text("Warehouses: ${warehouses.length}"),
              Text("Items: ${items.length}"),
              Text("Stocks (first warehouse): ${stocks.length}"),
              const SizedBox(height: 16),
              const CapacityStatusCard(),

              /// --- Data dummy
              TransactionSummary(stockIn: 1400, stockOut: 300),
              const SizedBox(height: 32),
              StockQuantityChart(
                stockInData: [0, 100, 0, 110, 105],
                stockOutData: [95, 0, 93, 0, 0],
              ),
            ],
          ),
        ),
      ),
    );
  }
}