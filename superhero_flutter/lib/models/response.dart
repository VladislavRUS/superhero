import 'package:superhero_flutter/models/client_details.dart';
import 'package:superhero_flutter/models/request.dart';

class Response {
  int id;
  int requestId;
  int contractorId;
  ClientDetails contractorDetails;
  String date;
  Request request;
  int payment;
  String plannedDate;

  Response.fromJson(map) {
    id = map['id'];
    requestId = map['requestId'];
    contractorId = map['contractorId'];
    contractorDetails = ClientDetails.fromJson(map['contractorDetails']);
    date = map['date'];
    request = Request.fromJson(map['request']);
    payment = map['payment'];
    plannedDate = map['plannedDate'];
  }
}
