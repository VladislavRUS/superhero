import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/constants/routes.dart';
import 'package:superhero_flutter/screens/app.dart';
import 'package:superhero_flutter/screens/create_request.dart';
import 'package:superhero_flutter/screens/detailed_request.dart';
import 'package:superhero_flutter/screens/initial.dart';
import 'package:superhero_flutter/screens/login.dart';
import 'package:superhero_flutter/store.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Store store = new Store();

  runApp(ScopedModel(model: store, child: MainScreen()));
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.INITIAL,
      routes: {
        Routes.INITIAL: (context) => InitialScreen(),
        Routes.LOGIN: (context) => LoginScreen(),
        Routes.APP: (context) => AppScreen(),
        Routes.CREATE_REQUEST: (context) => CreateRequestScreen(),
        Routes.DETAILED_REQUEST: (context) => DetailedRequestScreen()
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('ru', 'RU'),
      ],
    );
  }
}
