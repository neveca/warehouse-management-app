import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final Function(int?) onQuantitySelected;
  final int? selectedQuantity; // tambahkan ini

  const QuantitySelector({
    super.key,
    required this.onQuantitySelected,
    this.selectedQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final quantities = [10, 100, 500, 1000, 10000];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ...quantities.map((q) {
          final isSelected = selectedQuantity == q;

          return ChoiceChip(
            label: Text('$q'),
            selected: isSelected,
            selectedColor: Colors.deepPurple,
            onSelected: (_) => onQuantitySelected(q),
          );
        }),
        ChoiceChip(
          label: const Text("Other"),
          selected: selectedQuantity == null,
          selectedColor: Colors.deepPurple.shade400,
          onSelected: (_) => onQuantitySelected(null),
        )
      ],
    );
  }
}
