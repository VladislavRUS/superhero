import 'package:intl/intl.dart';
import 'package:requests/requests.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/models/client_details.dart';
import 'package:superhero_flutter/models/feedback.dart';
import 'package:superhero_flutter/models/message.dart';
import 'package:superhero_flutter/models/request.dart';
import 'package:superhero_flutter/models/response.dart';

//String baseUrl = 'http://10.0.2.2:8080';
String baseUrl = 'https://0f4c53b9.ngrok.io';

class Store extends Model {
  String token;
  ClientDetails clientDetails;
  Request detailedRequest;
  Response currentResponse;
  List<Request> requests;
  List<Response> responses;
  List<Message> messages;
  List<Feedback> feedbacks;

  login(String email, String password) async {
    var response = await Requests.post(baseUrl + '/api/v1/login',
        body: {'email': email, 'password': password}, json: true);
    token = response['token'];
    clientDetails = ClientDetails.fromJson(response['clientDetails']);
  }

  fetchRequests() async {
    var jsonRequests = await Requests.get(baseUrl + '/api/v1/auth/requests',
        headers: {'Authorization': token}, json: true);

    requests = List<Request>();

    jsonRequests.forEach((jsonRequest) {
      requests.add(Request.fromJson(jsonRequest));
    });

    notifyListeners();
  }

  createRequest(String title, String budget, String description,
      String expirationDate) async {
    var body = {
      'title': title,
      'budget': budget,
      'description': description,
      'expirationDate': expirationDate
    };

    await Requests.post(baseUrl + '/api/v1/auth/requests',
        headers: {'Authorization': token}, body: body);
  }

  setDetailedRequest(Request request) {
    detailedRequest = request;
  }

  setCurrentResponse(Response response) {
    currentResponse = response;
  }

  confirmRequest(int requestId) async {
    await Requests.post(
        baseUrl + '/api/v1/auth/requests/${requestId.toString()}/confirm',
        headers: {'Authorization': token});

    notifyListeners();
  }

  respond(int requestId) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    var body = {'requestId': requestId, 'date': date};

    await Requests.post(baseUrl + '/api/v1/auth/responses',
        headers: {'Authorization': token}, body: body);

    notifyListeners();
  }

  fetchResponses() async {
    String url = baseUrl + '/api/v1/auth/responses';

    var jsonResponses =
        await Requests.get(url, headers: {'Authorization': token}, json: true);

    responses = List<Response>();

    jsonResponses.forEach((jsonResponse) {
      responses.add(Response.fromJson(jsonResponse));
    });

    notifyListeners();
  }

  fetchMessages(int responseId) async {
    String url =
        baseUrl + '/api/v1/auth/responses/${responseId.toString()}/messages';

    var jsonMessages =
        await Requests.get(url, headers: {'Authorization': token}, json: true);

    messages = List<Message>();

    jsonMessages.forEach((jsonMessage) {
      messages.add(Message.fromJson(jsonMessage));
    });

    notifyListeners();
  }

  sendMessage(int responseId, String text) async {
    String url =
        baseUrl + '/api/v1/auth/responses/${responseId.toString()}/messages';
    var body = {"text": text};
    await Requests.post(url, headers: {'Authorization': token}, body: body);
  }

  assign(int requestId, int contractorId) async {
    String url = baseUrl +
        '/api/v1/auth/requests/${requestId.toString()}/assign?contractorId=${contractorId.toString()}';
    await Requests.post(url, headers: {'Authorization': token});
    detailedRequest.contractorId = contractorId;
  }

  finish(int requestId) async {
    String url =
        baseUrl + '/api/v1/auth/requests/${requestId.toString()}/finish';
    await Requests.post(url, headers: {'Authorization': token});
    detailedRequest.isFinished = true;
  }

  fetchFeedbacks(int contractorId) async {
    String url =
        baseUrl + '/api/v1/auth/feedbacks?contractorId=${contractorId.toString()}';
    var jsonFeedbacks = await Requests.get(url, headers: {'Authorization': token}, json: true);

    feedbacks = List<Feedback>();

    jsonFeedbacks.forEach((jsonFeedback) {
      feedbacks.add(Feedback.fromJson(jsonFeedback));
    });

    notifyListeners();
  }

  createFeedback(String comment, int value, int contractorId) async {
    String url =
        baseUrl + '/api/v1/auth/feedbacks';
    var body = {
      "comment": comment,
      "value": value,
      "contractorId": contractorId
    };

    await Requests.post(url, headers: {'Authorization': token}, body: body);
  }
}
