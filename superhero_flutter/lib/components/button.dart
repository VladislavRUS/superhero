import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:superhero_flutter/constants/app_colors.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isLoading;

  Button({this.text, this.onTap, this.isLoading});

  _onTap() {
    if (isLoading) {
      return;
    }

    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: isLoading
            ? SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : Text(text, style: TextStyle(color: Colors.white)),
        onPressed: _onTap,
        color: AppColors.MAIN_COLOR);
  }
}
