import 'package:flutter/material.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.HEADER_TEXT_COLOR,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: AppBarText(text: 'Настройки'),
      ),
      body: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Opacity(
                opacity: 0.7,
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.settings)),
              ),
              Text('Раздел в разработке'),
            ],
          ),
        ),
      ),
    );
  }
}
