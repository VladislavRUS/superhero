import 'package:flutter/material.dart';
import 'package:superhero_flutter/constants/routes.dart';

class InitialScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InitialScreenState();
  }
}

class InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();

    Future(() {
      Navigator.pushReplacementNamed(context, Routes.LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: CircularProgressIndicator()));
  }
}