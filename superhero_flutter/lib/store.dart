import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:requests/requests.dart';

String baseUrl = 'http://10.0.2.2:8080';

class Store extends Model {
  String token;
  dynamic requests;

  login(String email, String password) async {
    var response =  await Requests.post(baseUrl + '/api/v1/login', body: { "email": email, "password": password }, json: true);
    token = response['token'];
    print(token);
  }

  fetchRequests() async {
    var response = await Requests.get(baseUrl + '/api/v1/auth/requests', headers: { 'Authorization': token });
    requests =  json.decode(response);
    notifyListeners();
  }
}

