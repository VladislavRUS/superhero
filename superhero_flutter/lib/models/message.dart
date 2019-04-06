class Message {
  int id;
  int responseId;
  int senderId;
  String text;
  String timestamp;
  bool isSystem;

  Message.fromJson(map) {
    id = map['id'];
    responseId = map['responseId'];
    senderId = map['senderId'];
    text = map['text'];
    timestamp = map['timestamp'];
    isSystem = map['isSystem'];
  }
}
