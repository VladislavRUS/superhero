import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/button.dart';
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
      appBar: AppBar(title: Text('Комментарий')),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: commentController,
            ),
            TextField(
                keyboardType: TextInputType.numberWithOptions(),
                controller: valueController),
            Button(
                text: 'Сохранить отзыв',
                onTap: onCreateFeedback,
                isLoading: isLoading)
          ],
        ),
      ),
    );
  }
}
