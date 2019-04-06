import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/components/info.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/store.dart';

class FeedbacksScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeedbacksScreenState();
  }
}

class FeedbacksScreenState extends State<FeedbacksScreen> {
  bool isLoading = false;
  String average = '';

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
  void initState() {
    this.init();
    super.initState();
  }

  init() async {
    showLoader();
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchFeedbacks(store.currentResponse.contractorId);
      countAverage();
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

  countAverage() {
    Store store = ScopedModel.of<Store>(context);

    double sum = 0;

    store.feedbacks.forEach((feedback) {
      sum += feedback.value;
    });

    sum /= store.feedbacks.length;
    average = sum.toStringAsFixed(1);
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
        title: AppBarText(text: 'Отзывы'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Info(
                    name: 'Среднее',
                    value: average,
                  )
                ],
              ),
            ),
    );
  }
}
