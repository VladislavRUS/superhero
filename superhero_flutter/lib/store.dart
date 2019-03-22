import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:requests/requests.dart';
import 'package:superhero_flutter/models/request.dart';

String baseUrl = 'http://10.0.2.2:8080';
//String baseUrl = 'http://ed4324ae.ngrok.io';

class Store extends Model {
  String token;
  String role;
  List<Request> requests;
  Request detailedRequest;

  login(String email, String password) async {
    var response = await Requests.post(baseUrl + '/api/v1/login',
        body: {'email': email, 'password': password}, json: true);
    token = response['token'];

    var clientDetails = response['clientDetails'];
    role = clientDetails['role'];
  }

  fetchRequests() async {
    var response = await Requests.get(baseUrl + '/api/v1/auth/requests',
        headers: {'Authorization': token});
    var jsonResponses = json.decode(response);

    requests = List<Request>();

    jsonResponses.forEach((json) {
      requests.add(Request.fromJson(json));
    });

    notifyListeners();
  }

  createRequest(String description, String expirationDate) async {
    var body = {'description': description, 'expirationDate': expirationDate};

    await Requests.post(baseUrl + '/api/v1/auth/requests',
        headers: {'Authorization': token}, body: body, json: true);
  }

  setDetailedRequest(Request request) {
    detailedRequest = request;
  }

  confirmRequest(int requestId) async {
    await Requests.post(
        baseUrl + '/api/v1/auth/requests/' + requestId.toString() + '/confirm',
        headers: {'Authorization': token});

    notifyListeners();
  }
}
