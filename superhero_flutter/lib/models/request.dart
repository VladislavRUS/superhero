import 'package:superhero_flutter/constants/request_types.dart';
import 'package:superhero_flutter/models/client_details.dart';

class Request {
  int id;
  int customerId;
  ClientDetails customerDetails;
  int contractorId;
  ClientDetails contractorDetails;
  String type;
  String typeValue;
  String address;
  String expirationDate;
  String publishDate;
  bool isFinishedByCustomer;
  bool isFinishedByContractor;
  bool isApproved;
  int responseCount;

  Request.fromJson(map) {
    id = map['id'];
    customerId = map['customerId'];
    customerDetails = ClientDetails.fromJson(map['customerDetails']);
    contractorId = map['contractorId'];
    contractorDetails = contractorId == null
        ? null
        : ClientDetails.fromJson(map['customerDetails']);
    type = map['type'];
    typeValue = RequestTypes.getTypeValue(type);
    address = map['address'];
    expirationDate = map['expirationDate'];
    publishDate = map['publishDate'];
    isFinishedByCustomer = map['isFinishedByCustomer'];
    isFinishedByContractor = map['isFinishedByContractor'];
    isApproved = map['isApproved'];
    responseCount = map['responseCount'];
  }
}
