import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/store.dart';
import 'package:intl/intl.dart';

class CreateRequestScreen extends StatefulWidget {
  @override
  CreateRequestScreenState createState() => CreateRequestScreenState();
}

class CreateRequestScreenState extends State<CreateRequestScreen> {
  TextEditingController expirationDateFieldController =
      new TextEditingController();
  TextEditingController titleFieldController = new TextEditingController();
  TextEditingController descriptionFieldController =
      new TextEditingController();
  bool isSaving = false;
  double budget = 1;

  hideKeyboard() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 350));
  }

  openDatePicker() async {
    await hideKeyboard();

    DateTime now = DateTime.now();
    Duration year = Duration(days: 365);
    DateTime lastDate = now.add(year);
    DateTime firstDate = now;
    DateTime initialDate = firstDate;
    DateTime date = await showDatePicker(
        locale: Locale('ru'),
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);

    if (date != null) {
      expirationDateFieldController.text =
          DateFormat('yyyy-MM-dd').format(date);
    }
  }

  onSave() {
    if (descriptionFieldController.text == '' ||
        expirationDateFieldController.text == '' ||
        titleFieldController.text == '') {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text('Ошибка!'),
                content: Text('Заполните, пожалуйста, все поля'));
          });
    } else {
      save();
    }
  }

  save() async {
    Store store = ScopedModel.of<Store>(context);

    showLoader();

    String title = titleFieldController.text;
    String budgetStr = budget.toInt().toString();
    String description = descriptionFieldController.text;
    String expirationDate = expirationDateFieldController.text;

    try {
      await store.createRequest(title, budgetStr, description, expirationDate);
    } catch (e) {} finally {
      hideLoader();
    }

    Navigator.pop(context);
  }

  showLoader() {
    setState(() {
      isSaving = true;
    });
  }

  hideLoader() {
    setState(() {
      isSaving = false;
    });
  }

  @override
  void dispose() {
    descriptionFieldController.dispose();
    expirationDateFieldController.dispose();
    titleFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создайте заявку'),
      ),
      body: isSaving
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: titleFieldController,
                          decoration: InputDecoration(labelText: 'Название'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: descriptionFieldController,
                          decoration: InputDecoration(labelText: 'Описание'),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Бюджет, ${budget.toInt().toString()} тыс.'),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Slider(value: budget, min: 1, max: 1000, onChanged: (newValue) {
                              setState(() {
                                budget = newValue;
                              });
                            }),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: openDatePicker,
                          child: AbsorbPointer(
                            child: TextField(
                              enabled: false,
                              decoration:
                                  InputDecoration(hintText: 'Выберите дату'),
                              controller: expirationDateFieldController,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: onSave, child: Center(child: Icon(Icons.check))),
    );
  }
}
