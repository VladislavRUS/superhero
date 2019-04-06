import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/components/button.dart';
import 'package:superhero_flutter/components/input.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/store.dart';

class CreateResponseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateResponseScreenState();
  }
}

class CreateResponseScreenState extends State<CreateResponseScreen> {
  TextEditingController paymentController = TextEditingController();
  TextEditingController plannedDateController = TextEditingController();

  bool isLoading = false;

  showLoader() {
    setState(() {
      isLoading = true;
    });
  }

  hideLoader() {
    setState(() {
      isLoading = false;
    });
  }

  hideKeyboard() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 250));
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
      plannedDateController.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  onRespond() async {
    Store store = ScopedModel.of<Store>(context);

    showLoader();

    try {
      await store.respond(store.detailedRequest.id, plannedDateController.text,
          paymentController.text);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

  @override
  void dispose() {
    plannedDateController.dispose();
    paymentController.dispose();
    super.dispose();
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
        title: AppBarText(text: 'Отклик'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: openDatePicker,
                      child: AbsorbPointer(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.BORDER_COLOR),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: TextField(
                              enabled: false,
                              controller: plannedDateController,
                              decoration: InputDecoration(
                                  hintText: 'Выберите дату выполнения',
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
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Input(
                controller: paymentController,
                hintText: 'Введите стоимость',
                inputType: TextInputType.numberWithOptions(),
              ),
            ),
            Button(onTap: onRespond, isLoading: isLoading, text: 'Подтвердить')
          ],
        ),
      ),
    );
  }
}
