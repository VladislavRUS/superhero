import 'package:superhero_flutter/models/client_details.dart';
import 'package:superhero_flutter/models/request.dart';

class Response {
  int id;
  int requestId;
  int contractorId;
  String date;
  ClientDetails customerDetails;
  ClientDetails contractorDetails;
  Request request;

  Response.fromJson(map) {
    id = map['id'];
    requestId = map['requestId'];
    contractorId = map['contractorId'];
    date = map['date'];
    customerDetails = ClientDetails.fromJson(map['customerDetails']);
    contractorDetails = ClientDetails.fromJson(map['contractorDetails']);
    request = Request.fromJson(map['request']);
  }
}