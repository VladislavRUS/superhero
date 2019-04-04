import 'package:flutter/material.dart';
import 'package:superhero_flutter/constants/app_colors.dart';

class AppBarText extends StatelessWidget {
  final String text;

  AppBarText({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(this.text,
        style: TextStyle(fontSize: 22, color: AppColors.HEADER_TEXT_COLOR));
  }
}
