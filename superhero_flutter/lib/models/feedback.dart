class Feedback {
  int id;
  int customerId;
  int contractorId;
  int value;
  String comment;

  Feedback.fromJson(map) {
    id = map['id'];
    customerId = map['customerId'];
    contractorId = map['contractorId'];
    value = map['value'];
    comment = map['comment'];
  }
}