import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
    hideLoader();

    updateTimer = new Timer(Duration(seconds: 1), fetchMessages);
  }

  fetchMessages() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchMessages(store.currentResponse.id);
      if (scrollController.position != null) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
      }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат'),
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
