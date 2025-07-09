import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/item_service.dart';
import '../../api/warehouse_service.dart';
import '../../api/stock_service.dart';
import '../../api/auth_provider.dart';

class StockOutScreen extends StatefulWidget {
  const StockOutScreen({super.key});

  @override
  State<StockOutScreen> createState() => _StockOutScreenState();
}

class _StockOutScreenState extends State<StockOutScreen> {
  List<dynamic> items = [];
  List<dynamic> warehouses = [];
  String? selectedItemName;
  String? selectedWarehouseName;
  int? quantity;
  DateTime? selectedDate;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController manualQuantityController = TextEditingController();
  bool isOtherSelected = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication required")),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      items = await ItemService.getAllItems(token);
      warehouses = await WarehouseService.getAllWarehouses(token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: $e")),
      );
    }
    setState(() => isLoading = false);
  }

  int? getItemIdByName(String? name) =>
      items.firstWhere((e) => e["item_name"] == name, orElse: () => null)?["item_id"];
  int? getWarehouseIdByName(String? name) =>
      warehouses.firstWhere((e) => e["warehouse_name"] == name, orElse: () => null)?["warehouse_id"];

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _resetForm() {
    setState(() {
      selectedItemName = null;
      selectedWarehouseName = null;
      quantity = null;
      isOtherSelected = false;
      selectedDate = null;
      noteController.clear();
      manualQuantityController.clear();
    });
  }

  Future<void> _saveForm() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication required")),
      );
      return;
    }

    if (isOtherSelected && manualQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter quantity")),
      );
      return;
    }

    final finalQuantity = isOtherSelected
        ? int.tryParse(manualQuantityController.text)
        : quantity;

    final itemId = getItemIdByName(selectedItemName);
    final warehouseId = getWarehouseIdByName(selectedWarehouseName);

    if (itemId == null || warehouseId == null || finalQuantity == null || finalQuantity <= 0 || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final stocks = await StockService.getByWarehouse(token, warehouseId);
      var stock = stocks.firstWhere((s) => s['item_id'] == itemId, orElse: () => null);
      if (stock == null || stock['quantity'] < finalQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Insufficient stock")),
        );
        setState(() => isLoading = false);
        return;
      }
      int newQty = stock['quantity'] - finalQuantity;

      final success = await StockService.upsertStock(token, {
        "warehouse_id": warehouseId,
        "item_id": itemId,
        "quantity": newQty,
        "last_updated": DateTime.now().toIso8601String(),
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text("Stock out successful!"),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        _resetForm();
      } else {
        throw Exception("API failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemNames = items.map((e) => e["item_name"].toString()).toList();
    final warehouseNames = warehouses.map((e) => e["warehouse_name"].toString()).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Outgoing Stock")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedItemName,
              items: itemNames
                  .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (val) => setState(() => selectedItemName = val),
              decoration: const InputDecoration(labelText: "Item", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: "Date of transaction", border: OutlineInputBorder()),
                child: Text(
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "Select date",
                  style: TextStyle(
                    color: selectedDate != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedWarehouseName,
              items: warehouseNames
                  .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (val) => setState(() => selectedWarehouseName = val),
              decoration: const InputDecoration(labelText: "Warehouse", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [10, 100, 500, 1000, 10000].map((q) {
                final isSelected = quantity == q && !isOtherSelected;
                return ChoiceChip(
                  label: Text('$q'),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple,
                  onSelected: (_) {
                    setState(() {
                      isOtherSelected = false;
                      quantity = q;
                    });
                  },
                );
              }).toList()
                ..add(ChoiceChip(
                  label: const Text("Other"),
                  selected: isOtherSelected,
                  selectedColor: Colors.deepPurple.shade400,
                  onSelected: (_) {
                    setState(() {
                      isOtherSelected = true;
                      quantity = null;
                    });
                  },
                )),
            ),
            if (isOtherSelected) ...[
              const SizedBox(height: 8),
              TextField(
                controller: manualQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter custom quantity'),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Note...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetForm,
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveForm,
                    child: const Text("Save"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
