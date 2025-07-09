/*
import 'package:flutter/material.dart';
import 'widgets/action_button.dart';
import 'widgets/capacity_status_card.dart';
import 'widgets/warehouse_progress_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Caligula Warehouse", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

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
              children: const [
                ActionButton(icon: Icons.download, label: 'Stock in', color: Colors.purple),
                ActionButton(icon: Icons.upload, label: 'Stock out', color: Colors.red),
                ActionButton(icon: Icons.bar_chart, label: 'Report', color: Colors.teal),
                ActionButton(icon: Icons.file_copy, label: 'Export', color: Colors.blue),
              ],
            ),

            const SizedBox(height: 32),
            const CapacityStatusCard(),
          ],
        ),
      ),
    );
  }
}
*/