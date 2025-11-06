import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final DateTime createdAt;

  const Item({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Item.fromMap(String id, Map<String, dynamic> map) {
    // Safely parse numeric values that may be stored as int or double
    final num quantityNum = map['quantity'] ?? 0;
    final num priceNum = map['price'] ?? 0.0;

    final Timestamp? ts = map['createdAt'] is Timestamp
        ? map['createdAt'] as Timestamp
        : null;

    return Item(
      id: id,
      name: (map['name'] ?? '') as String,
      quantity: quantityNum.toInt(),
      price: priceNum.toDouble(),
      category: (map['category'] ?? '') as String,
      createdAt: ts?.toDate() ?? DateTime.now(),
    );
  }
}
