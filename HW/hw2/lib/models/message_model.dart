class MessageModel {
  final String id;
  final String boardId;
  final String userId;
  final String username;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.boardId,
    required this.userId,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'boardId': boardId,
      'userId': userId,
      'username': username,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      boardId: map['boardId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}

