import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  String text;

  FormText({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Colors.red));
  }
}
