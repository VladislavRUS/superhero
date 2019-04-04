import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
      fields.add(Text(clientDetails.companyName));
    } else {
      fields.add(Text(clientDetails.firstName));
      fields.add(Text(clientDetails.lastName));
    }

    fields.add(Text(clientDetails.email));
    fields.add(Text(clientDetails.about));

    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Container(
        child: Column(
          children: getInfoFields(),
        ),
      ),
    );
  }
}
