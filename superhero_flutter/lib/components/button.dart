import 'package:flutter/material.dart';
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
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Material(
        color: AppColors.MAIN_COLOR,
        child: InkWell(
            onTap: _onTap,
            child: Container(
              height: 40,
              child: Center(
                child: isLoading
                    ? (SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        width: 20,
                        height: 20))
                    : Text(text,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
              ),
            )),
      ),
    );
  }
}
