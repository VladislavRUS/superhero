import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/components/info.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/models/client_details.dart';
import 'package:superhero_flutter/store.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  List<Widget> getInfoFields() {
    List<Widget> fields = List();
    Store store = ScopedModel.of<Store>(context);
    ClientDetails clientDetails = store.clientDetails;

    if (clientDetails.isLegalEntity) {
      fields.add(Info(name: 'Компания', value: clientDetails.companyName));
    } else {
      fields.add(Info(name: 'Имя', value: clientDetails.firstName));
      fields.add(Info(name: 'Фамилия', value: clientDetails.lastName));
    }

    fields.add(Info(name: 'Почта', value: clientDetails.email));

    return fields;
  }

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
        title: AppBarText(text: 'Профиль'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getInfoFields(),
        ),
      ),
    );
  }
}
