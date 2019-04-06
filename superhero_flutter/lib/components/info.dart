import 'package:flutter/material.dart';
import 'package:superhero_flutter/constants/app_colors.dart';

class Info extends StatelessWidget {
  final String name;
  final String value;

  Info({this.name, this.value});

  getName() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(this.name,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppColors.HEADER_TEXT_COLOR)),
        ),
      ],
    );
  }

  getValue() {
    return Text(this.value,
        style: TextStyle(fontSize: 18, color: AppColors.TEXT_COLOR));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[getName(), getValue()],
      ),
    );
  }
}
