import 'package:flutter/material.dart';
import 'warehouse_progress_bar.dart';

class CapacityStatusCard extends StatelessWidget {
  const CapacityStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Warehouse capacity", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Good", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text("You've maintained the warehouse on track! Keep it up!"),

          const SizedBox(height: 16),
          const WarehouseProgressBar(progress: 0.65),
        ],
      ),
    );
  }
}
