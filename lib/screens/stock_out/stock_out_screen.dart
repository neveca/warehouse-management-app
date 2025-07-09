import 'package:flutter/material.dart';
import '../../models/stock_transaction.dart';
import '../../database/db_helper.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/stock_dropdown.dart';

class StockOutScreen extends StatefulWidget {
  const StockOutScreen({super.key});

  @override
  State<StockOutScreen> createState() => _StockOutScreenState();
}

class _StockOutScreenState extends State<StockOutScreen> {
  String? selectedItem;
  DateTime? selectedDate;
  String? selectedOrigin;
  int? quantity;
  final noteController = TextEditingController();
  final manualQuantityController = TextEditingController();
  bool isOtherSelected = false;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _resetForm() {
    setState(() {
      selectedItem = null;
      selectedDate = null;
      selectedOrigin = null;
      quantity = null;
      isOtherSelected = false;
      manualQuantityController.clear();
      noteController.clear();
    });
  }

  void _saveForm() async {
    if (isOtherSelected && manualQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter quantity")),
      );
      return;
    }

    final finalQuantity = isOtherSelected
        ? int.tryParse(manualQuantityController.text)
        : quantity;

    if (selectedItem != null &&
        selectedDate != null &&
        selectedOrigin != null &&
        finalQuantity != null &&
        finalQuantity > 0) {
      final tx = StockTransaction(
        item: selectedItem!,
        date: selectedDate!.toIso8601String(),
        destination: selectedOrigin!, // tetap gunakan destination field
        quantity: finalQuantity,
        note: noteController.text,
      );

      await DBHelper.insertTransaction(tx);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text("Stock out saved!"),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      _resetForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Outgoing Stock")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StockDropdown(
              label: "Item",
              value: selectedItem,
              items: const ['Rosemary', 'Basil', 'Parsley'],
              onChanged: (val) => setState(() => selectedItem = val),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Date of transaction",
                  border: OutlineInputBorder(),
                ),
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
            StockDropdown(
              label: "Destination Warehouse",
              value: selectedOrigin,
              items: const ['Boulevard Warehouse', 'Main Warehouse'],
              onChanged: (val) => setState(() => selectedOrigin = val),
            ),
            const SizedBox(height: 16),
            QuantitySelector(
              selectedQuantity: quantity,
              onQuantitySelected: (val) {
                setState(() {
                  if (val == null) {
                    isOtherSelected = true;
                    quantity = null;
                  } else {
                    isOtherSelected = false;
                    quantity = val;
                  }
                });
              },
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
                    onPressed: _saveForm,
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
