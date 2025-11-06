import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirestoreService {
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('items');

  Future<void> addItem(Item item) async {
    await _items.add(item.toMap());
  }

  Stream<List<Item>> getItemsStream() {
    return _items
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Item.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateItem(Item item) async {
    if (item.id == null) {
      throw Exception('Item must have an id to update');
    }
    await _items.doc(item.id).set(item.toMap());
  }

  Future<void> deleteItem(String itemId) async {
    await _items.doc(itemId).delete();
  }
}
