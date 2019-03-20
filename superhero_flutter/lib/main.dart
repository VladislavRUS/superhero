import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/screens/login.dart';
import 'package:superhero_flutter/screens/requests.dart';
import 'package:superhero_flutter/store.dart';

void main() {
  Store store = new Store();

  runApp(ScopedModel(model: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Superhero',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/requests': (context) => RequestsScreen()
        }
    );
  }
}
