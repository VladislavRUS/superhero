class Request {
  int id;
  int customerId;
  int contractorId;
  String title;
  int budget;
  String description;
  String expirationDate;
  String publishDate;
  bool isConfirmed;
  bool isFinished;
  int responseCount;

  Request.fromJson(map) {
    id = map['id'];
    customerId = map['customerId'];
    contractorId = map['contractorId'];
    title = map['title'];
    budget = map['budget'];
    description = map['description'];
    expirationDate = map['expirationDate'];
    publishDate = map['publishDate'];
    isConfirmed = map['isConfirmed'];
    isFinished = map['isFinished'];
    responseCount = map['responseCount'];
  }
}