import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/constants/actions.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/constants/roles.dart';
import 'package:superhero_flutter/constants/routes.dart';
import 'package:superhero_flutter/models/choice.dart';
import 'package:superhero_flutter/models/message.dart';
import 'package:superhero_flutter/store.dart';

class MessagesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessagesScreenState();
  }
}

class MessagesScreenState extends State<MessagesScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  Timer updateTimer;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    showLoader();
    await fetchMessages();
    await fetchFeedbacks();
    hideLoader();

    updateTimer = new Timer.periodic(Duration(seconds: 1), (timer) {
      fetchMessages();
      updateCurrentResponse();
    });
  }

  fetchMessages() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchMessages(store.currentResponse.id);
    } catch (e) {
      print(e);
    }
  }

  fetchFeedbacks() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchFeedbacks(store.currentResponse.contractorId);
    } catch (e) {
      print(e);
    }
  }

  updateCurrentResponse() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchResponses();
      store.currentResponse = store.responses
          .firstWhere((response) => response.id == store.currentResponse.id);
    } catch (e) {
      print(e);
    }
  }

  void hideLoader() {
    setState(() {
      isLoading = false;
    });
  }

  void showLoader() {
    setState(() {
      isLoading = true;
    });
  }

  void send() async {
    Store store = ScopedModel.of<Store>(context);
    FocusScope.of(context).requestFocus(new FocusNode());

    try {
      await store.sendMessage(
          store.currentResponse.id, textEditingController.text);
      fetchMessages();
    } catch (e) {
      print(e);
    }

    textEditingController.text = '';
  }

  bool isSender(Message message) {
    Store store = ScopedModel.of<Store>(context);

    return store.clientDetails.id == message.senderId;
  }

  Widget buildMessagesList() {
    Store store = ScopedModel.of<Store>(context);
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView.builder(
          controller: scrollController,
          itemCount: store.messages.length,
          itemBuilder: (context, index) {
            Message message = store.messages[index];
            return Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: !isSender(message)
                    ? message.senderId == null
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Color.fromARGB(10, 0, 0, 0),
                                blurRadius: 10,
                                spreadRadius: 1)
                          ],
                          border:
                              Border.all(color: Color.fromARGB(20, 0, 0, 0)),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: !isSender(message)
                              ? message.senderId == null
                                  ? Color.fromARGB(10, 0, 255, 0)
                                  : Colors.white
                              : AppColors.MAIN_COLOR_LIGHTER),
                      width: 200,
                      child: Text(
                        message.text,
                        textAlign: message.senderId == null
                            ? TextAlign.center
                            : TextAlign.left,
                        style: TextStyle(height: 1.2),
                      ))
                ].reversed.toList(),
              ),
            );
          }),
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 80,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: 'Введите сообщение'),
          ))),
          Material(
            child: InkWell(
              onTap: send,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.send,
                  color: AppColors.MAIN_COLOR,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    updateTimer.cancel();
    super.dispose();
  }

  List<Choice> getMenuItems() {
    List<Choice> choices = List();

    Store store = ScopedModel.of<Store>(context);

    if (store.clientDetails.role == Roles.CUSTOMER) {
      choices
          .add(Choice(title: 'Посмотреть отзывы', action: Actions.WATCH_INFO));

      if (store.currentResponse.request.contractorId == null) {
        choices.add(
            Choice(title: 'Назначить исполняющим', action: Actions.ASSIGN));
      } else if (store.currentResponse.request.isFinishedByContractor &&
          !store.currentResponse.request.isFinishedByCustomer) {
        choices.add(Choice(title: 'Завершить заявку', action: Actions.FINISH));
      }
    }

    if (store.clientDetails.role == Roles.CONTRACTOR &&
        store.currentResponse.request.contractorId == store.clientDetails.id &&
        !store.currentResponse.request.isFinishedByContractor) {
      choices.add(Choice(title: 'Завершить заявку', action: Actions.FINISH));
    }
    return choices;
  }

  bool alreadyLeftFeedback() {
    bool leftFeedback = false;
    Store store = ScopedModel.of<Store>(context);

    if (store.feedbacks != null) {
      for (int i = 0; i < store.feedbacks.length; i++) {
        if (store.feedbacks[i].customerId == store.clientDetails.id) {
          leftFeedback = true;
          break;
        }
      }
    }

    return leftFeedback;
  }

  onAction(Choice choice) {
    if (choice.action == Actions.ASSIGN) {
      assign();
    } else if (choice.action == Actions.FINISH) {
      finish();
    } else if (choice.action == Actions.WATCH_INFO) {
      Navigator.of(context).pushNamed(Routes.FEEDBACKS);
    }
  }

  assign() async {
    showLoader();
    Store store = ScopedModel.of<Store>(context);

    try {
      int requestId = store.currentResponse.request.id;
      int contractorId = store.currentResponse.contractorId;
      await store.assign(requestId, contractorId);
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

  finish() async {
    showLoader();
    Store store = ScopedModel.of<Store>(context);

    try {
      int requestId = store.currentResponse.request.id;
      await store.finish(requestId);

      if (store.clientDetails.role == Roles.CUSTOMER) {
        _showDialog();
      }
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Хотите оставить отзыв?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Да'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, Routes.CREATE_FEEDBACK);
                },
              ),
              FlatButton(
                child: Text('Нет'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<Store>(context, rebuildOnChange: true);

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
          title: AppBarText(text: 'Чат'),
          actions: getMenuItems().length > 0
              ? <Widget>[
                  PopupMenuButton<Choice>(
                    icon: Icon(Icons.more_vert,
                        color: AppColors.HEADER_TEXT_COLOR),
                    onSelected: onAction,
                    itemBuilder: (BuildContext context) {
                      return getMenuItems().map((Choice choice) {
                        return PopupMenuItem<Choice>(
                          value: choice,
                          child: Text(choice.title),
                        );
                      }).toList();
                    },
                  ),
                ]
              : null),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Container(child: buildMessagesList())),
                buildForm()
              ],
            ),
    );
  }
}
