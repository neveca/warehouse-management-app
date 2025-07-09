import 'package:flutter/material.dart';
import '../stock_in/stock_in_screen.dart';
import 'widgets/action_button.dart';
import 'widgets/capacity_status_card.dart';
import 'widgets/warehouse_progress_bar.dart';
import '../stock_out/stock_out_screen.dart';
import '../report/report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Caligula Warehouse", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, )),

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
                          builder: (context) => const StockInScreen(),
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
                          builder: (context) => const StockOutScreen(),
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
                        MaterialPageRoute(builder: (context) => const ReportScreen()),
                      );
                    },
                  ),
                  const ActionButton(icon: Icons.file_copy, label: 'Export', color: Colors.blue),
                ],
              ),

              const SizedBox(height: 32),
              const CapacityStatusCard(),
            ],
          ),
        ),
      ),
    );
  }
}
