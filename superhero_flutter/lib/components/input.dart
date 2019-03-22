import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;

  Input({this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 190, 202, 214), width: 1),
          ),
        ),
        style:
            TextStyle(fontSize: 16, color: Color.fromARGB(255, 61, 81, 112)));
  }
}
