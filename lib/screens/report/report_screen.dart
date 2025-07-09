import 'package:flutter/material.dart';
import '../../database/db_helper.dart';
import '../../models/stock_transaction.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<StockTransaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DBHelper.getTransactions();
    setState(() {
      transactions = data;
    });
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Report")),
      body: transactions.isEmpty
          ? const Center(child: Text("No transactions recorded."))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Text(
                  tx.quantity.toString(),
                  style: const TextStyle(color: Colors.deepPurple),
                ),
              ),
              title: Text(tx.item),
              subtitle: Text(
                "Warehouse: ${tx.destination}\nDate: ${_formatDate(tx.date)}"
                    "${tx.note != null && tx.note!.isNotEmpty ? "\nNote: ${tx.note}" : ""}",
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
