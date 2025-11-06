import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService _service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Dashboard')),
      body: StreamBuilder<List<Item>>(
        stream: _service.getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          final totalItems = items.length;
          final totalValue = items.fold<double>(0.0, (sum, it) => sum + (it.price * it.quantity));
          final outOfStock = items.where((it) => it.quantity <= 0).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Total unique items'),
                    trailing: Text('$totalItems'),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: const Text('Total inventory value'),
                    trailing: Text('\$${totalValue.toStringAsFixed(2)}'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Out of stock', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (outOfStock.isEmpty) const Text('No out-of-stock items')
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: outOfStock.length,
                      itemBuilder: (context, index) {
                        final it = outOfStock[index];
                        return ListTile(
                          title: Text(it.name),
                          subtitle: Text(it.category),
                        );
                      },
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
