import 'package:flutter/material.dart';

class ResponsesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResponsesScreenState();
  }
}

class ResponsesScreenState extends State<ResponsesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отклики'),
      ),
    );
  }
}
