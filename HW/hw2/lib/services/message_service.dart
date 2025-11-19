import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages(String boardId) {
    return _firestore
        .collection('messages')
        .where('boardId', isEqualTo: boardId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> sendMessage({
    required String boardId,
    required String userId,
    required String username,
    required String message,
  }) async {
    try {
      await _firestore.collection('messages').add({
        'boardId': boardId,
        'userId': userId,
        'username': username,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
}

