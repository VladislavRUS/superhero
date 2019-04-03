import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/button.dart';
import 'package:superhero_flutter/constants/actions.dart';
import 'package:superhero_flutter/constants/roles.dart';
import 'package:superhero_flutter/constants/routes.dart';
import 'package:superhero_flutter/models/choice.dart';
import 'package:superhero_flutter/models/request.dart';
import 'package:superhero_flutter/models/response.dart';
import 'package:superhero_flutter/store.dart';

class DetailedRequestScreen extends StatefulWidget {
  @override
  DetailedRequestState createState() => DetailedRequestState();
}

class DetailedRequestState extends State<DetailedRequestScreen> {
  bool isLoading = false;

  confirmRequest() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.confirmRequest(store.detailedRequest.id);
      store.detailedRequest.isConfirmed = true;
    } catch (e) {
      print(e);
    }
  }

  respond() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.respond(store.detailedRequest.id);
      store.detailedRequest.contractorId = store.clientDetails.id;
    } catch (e) {
      print(e);
    }
  }

  onAction(Choice choice) {
    if (choice.action == Actions.CONFIRM_REQUEST) {
      confirmRequest();
    } else if (choice.action == Actions.RESPOND) {
      respond();
    }
  }

  List<Choice> getMenuItems() {
    List<Choice> choices = List();

    Store store = ScopedModel.of<Store>(context);
    String role = store.clientDetails.role;

    if (role == Roles.ADMIN) {
      choices.add(Choice(
          title: 'Подвердить',
          action: Actions.CONFIRM_REQUEST,
          enabled: !store.detailedRequest.isConfirmed));
    }

    if (role == Roles.CONTRACTOR) {
      Response response = store.responses.firstWhere((response) {
          return response.contractorId == store.clientDetails.id &&
              response.requestId == store.detailedRequest.id;
        }, orElse: () => null);

      choices.add(Choice(
          title: 'Откликнуться',
          action: Actions.RESPOND,
          enabled: response == null));
    }

    return choices;
  }

  Widget field(String key, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(key),
          Text(value),
        ],
      ),
    );
  }

  Widget toResponsesButton() {
    return Button(text: 'Отклики', isLoading: false, onTap: () {
      Navigator.of(context).pushNamed(Routes.RESPONSES);
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    showLoader();

    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchResponses();
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

  showLoader() {
    setState(() {
      isLoading = true;
    });
  }

  hideLoader() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Store store = ScopedModel.of<Store>(context, rebuildOnChange: true);
    Request request = store.detailedRequest;

    return Scaffold(
      appBar: AppBar(
        title: Text('Заявка'),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onAction,
            itemBuilder: (BuildContext context) {
              return getMenuItems().map((Choice choice) {
                return PopupMenuItem<Choice>(
                  enabled: choice.enabled,
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: isLoading
          ? (Center(
              child: CircularProgressIndicator(),
            ))
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    field('Описание', request.description),
                    field('Дата', request.expirationDate),
                    field('Подтверждено', request.isConfirmed.toString()),
                    toResponsesButton()
                  ])),
    );
  }
}
