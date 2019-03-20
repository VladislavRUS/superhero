import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/models/request.dart';
import 'package:superhero_flutter/store.dart';

class DetailedRequestScreen extends StatefulWidget {
  @override
  DetailedRequestState createState() => DetailedRequestState();
}

class DetailedRequestState extends State<DetailedRequestScreen> {
  @override
  Widget build(BuildContext context) {
    Store store = ScopedModel.of<Store>(context);
    Request request = store.detailedRequest;

    return Scaffold(
      appBar: AppBar(title: Text('Заявка')),
      body: Container(
        padding: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(request.description),
        Text(request.expirationDate),
      ])),
    );
  }
}
