import 'package:flutter/material.dart';

class TransactionSummary extends StatelessWidget {
  final int stockIn;
  final int stockOut;

  const TransactionSummary({
    super.key,
    required this.stockIn,
    required this.stockOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Transaction", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("8 Jan - 15 Jan 2025"),
            TextButton.icon(
              onPressed: () {}, // dropdown logic nanti
              icon: const Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
              label: const Text("This week", style: TextStyle(color: Colors.deepPurple)),
            )
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.circle, size: 10, color: Colors.green),
                        SizedBox(width: 6),
                        Text("Stock in", style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("$stockIn items", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.circle, size: 10, color: Colors.red),
                        SizedBox(width: 6),
                        Text("Stock out", style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("$stockOut items", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
