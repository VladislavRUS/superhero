class Request {
  int id;
  int customerId;
  int contractorId;
  String description;
  String expirationDate;
  bool isConfirmed;
  int responseCount;

  Request.fromJson(map) {
    this.id = map['id'];
    this.customerId = map['customerId'];
    this.contractorId = map['contractorId'];
    this.description = map['description'];
    this.expirationDate = map['expirationDate'];
    this.isConfirmed = map['isConfirmed'];
    this.responseCount = map['responseCount'];
  }
}