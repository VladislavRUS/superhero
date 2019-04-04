import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/components/input.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
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
  TextEditingController budgetFieldController = new TextEditingController();
  TextEditingController descriptionFieldController =
      new TextEditingController();
  bool isSaving = false;

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
    String budgetStr = budgetFieldController.text;
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
    budgetFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: onSave,
              icon: Icon(
                Icons.check,
                color: AppColors.HEADER_TEXT_COLOR,
              ),
            )
          ],
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.HEADER_TEXT_COLOR,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: AppBarText(
            text: 'Создание заявки',
          ),
          elevation: 0,
          backgroundColor: Colors.white),
      body: isSaving
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Input(
                          controller: titleFieldController,
                          hintText: 'Название')),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Input(
                        maxLines: 5,
                        controller: descriptionFieldController,
                        hintText: 'Описание'),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Input(
                        controller: budgetFieldController,
                        hintText: 'Бюджет, тыс.',
                        inputType: TextInputType.numberWithOptions()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: openDatePicker,
                          child: AbsorbPointer(
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.BORDER_COLOR),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: TextField(
                                  enabled: false,
                                  controller: expirationDateFieldController,
                                  decoration: InputDecoration(
                                      hintText: 'Выберите дату',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(12)),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.INPUT_TEXT_COLOR)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
