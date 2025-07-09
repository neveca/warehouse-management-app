import 'package:flutter/material.dart';

class WarehouseProgressBar extends StatelessWidget {
  final double progress;

  const WarehouseProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("😊"),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            color: Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
