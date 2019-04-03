import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/constants/actions.dart';
import 'package:superhero_flutter/constants/roles.dart';
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

    updateTimer =
        new Timer.periodic(Duration(seconds: 1), (timer) => fetchMessages());
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
                mainAxisAlignment: isSender(message)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: <Widget>[Text(message.text)].reversed.toList(),
              ),
            );
          }),
    );
  }

  Widget buildForm() {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  child: TextField(controller: textEditingController))),
          MaterialButton(
            onPressed: send,
            child: InkWell(
              child: Icon(Icons.send),
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
      choices.add(Choice(
          title: 'Назначить исполняющим',
          action: Actions.ASSIGN,
          enabled: store.detailedRequest.contractorId == null));

      choices.add(Choice(
          title: 'Завершить заявку',
          action: Actions.FINISH,
          enabled: !store.detailedRequest.isFinished));

      choices.add(Choice(
          title: 'Оставить отзыв',
          action: Actions.CREATE_FEEDBACK,
          enabled: store.detailedRequest.isFinished && !alreadyLeftFeedback()));
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
    }
  }

  assign() async {
    showLoader();
    Store store = ScopedModel.of<Store>(context);

    try {
      int requestId = store.detailedRequest.id;
      int contractorId = store.currentResponse.contractorDetails.id;
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
      int requestId = store.detailedRequest.id;
      await store.finish(requestId);
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<Store>(context, rebuildOnChange: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Чат'),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onAction,
            itemBuilder: (BuildContext context) {
              return getMenuItems().map((Choice choice) {
                return PopupMenuItem<Choice>(
                  enabled: choice.enabled,
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
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
