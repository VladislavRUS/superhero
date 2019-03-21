import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/constants/actions.dart';
import 'package:superhero_flutter/constants/roles.dart';
import 'package:superhero_flutter/models/request.dart';
import 'package:superhero_flutter/store.dart';

class DetailedRequestScreen extends StatefulWidget {
  @override
  DetailedRequestState createState() => DetailedRequestState();
}

class Choice {
  String title;
  String action;
  bool enabled;

  Choice({this.title, this.action, this.enabled});
}

class DetailedRequestState extends State<DetailedRequestScreen> {
  confirmRequest() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.confirmRequest(store.detailedRequest.id);
      store.detailedRequest.isConfirmed = true;
    } catch (e) {
      print(e);
    }
  }

  onAction(Choice choice) {
    if (choice.action == Actions.CONFIRM_REQUEST) {
      confirmRequest();
    }
  }

  List<Choice> getMenuItems() {
    List<Choice> choices = List();

    Store store = ScopedModel.of<Store>(context);
    String role = store.role;

    if (role == Roles.ADMIN) {
      choices.add(Choice(
          title: 'Подвердить',
          action: Actions.CONFIRM_REQUEST,
          enabled: !store.detailedRequest.isConfirmed));
    }

    return choices;
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
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(request.description),
                Text(request.expirationDate),
                Text(request.isConfirmed.toString()),
              ])),
    );
  }
}
