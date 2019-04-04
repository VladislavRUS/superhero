import 'package:flutter/material.dart';
import 'package:superhero_flutter/constants/app_colors.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final Widget icon;
  final String hintText;
  final TextInputType inputType;
  final int maxLines;

  Input({this.controller, this.icon, this.hintText, this.inputType, this.maxLines = 1});

  List<Widget> getChildren() {
    List<Widget> children = List();

    if (icon != null) {
      children.add(Container(
          margin: EdgeInsets.only(left: 8),
          padding: EdgeInsets.only(right: 8),
          child: Opacity(child: icon, opacity: 0.7),
          decoration: BoxDecoration(
              border: Border(
                  right:
                      BorderSide(color: AppColors.BORDER_COLOR, width: 1)))));
    }

    children.add(Expanded(
      child: TextField(
          maxLines: maxLines,
          controller: controller,
          keyboardType:
              inputType != null ? inputType : TextInputType.text,
          decoration: InputDecoration(
              hintText: this.hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12)),
          style: TextStyle(fontSize: 16, color: AppColors.INPUT_TEXT_COLOR)),
    ));

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.BORDER_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Row(children: getChildren()));
  }
}
