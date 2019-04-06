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
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(7)),
      child: Material(
        color: AppColors.MAIN_COLOR,
        child: InkWell(
          onTap: _onTap,
          child: Container(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              child: Opacity(
                opacity: isLoading ? 0.7 : 1,
                child: Text(text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              )),
        ),
      ),
    );
  }
}
