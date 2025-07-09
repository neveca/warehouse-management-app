// lib/models/stock_transaction.dart

class StockTransaction {
  final int? id;
  final String item;
  final String destination;
  final int quantity;
  final String? note;
  final String date; // Simpan sebagai ISO string

  StockTransaction({
    this.id,
    required this.item,
    required this.destination,
    required this.quantity,
    this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'destination': destination,
      'quantity': quantity,
      'note': note,
      'date': date,
    };
  }

  factory StockTransaction.fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id'],
      item: map['item'],
      destination: map['destination'],
      quantity: map['quantity'],
      note: map['note'],
      date: map['date'],
    );
  }
}
