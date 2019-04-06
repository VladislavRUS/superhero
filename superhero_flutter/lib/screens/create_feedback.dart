import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/components/button.dart';
import 'package:superhero_flutter/components/input.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/store.dart';

class CreateFeedbackScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateFeedbackScreenState();
  }
}

class CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  TextEditingController commentController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  bool isLoading = false;

  onCreateFeedback() async {
    Store store = ScopedModel.of<Store>(context);

    String comment = commentController.text;
    int value = int.parse(valueController.text);

    showLoader();

    try {
      await store.createFeedback(
          comment, value, store.currentResponse.contractorId);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

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
        title: AppBarText(text: 'Отзыв'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Input(
                hintText: 'Напишите отзыв',
                maxLines: 5,
                controller: commentController,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Input(
                  hintText: "Оцените от 1 до 5",
                  inputType: TextInputType.numberWithOptions(),
                  controller: valueController),
            ),
            Button(
                text: 'Сохранить',
                onTap: onCreateFeedback,
                isLoading: isLoading)
          ],
        ),
      ),
    );
  }
}
