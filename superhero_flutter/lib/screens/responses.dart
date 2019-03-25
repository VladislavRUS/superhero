import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/constants/routes.dart';
import 'package:superhero_flutter/models/response.dart';
import 'package:superhero_flutter/store.dart';

class ResponsesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResponsesScreenState();
  }
}

class ResponsesScreenState extends State<ResponsesScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchResponses();
    } catch (e) {
      print(e);
    }
  }

  onResponse(Response response) async {
    ScopedModel.of<Store>(context).setCurrentResponse(response);
    await Navigator.pushNamed(context, Routes.MESSAGES);
  }

  Widget buildList() {
    List<Response> responses = ScopedModel.of<Store>(context).responses;

    return ListView.builder(
        itemCount: responses != null ? responses.length : 0,
        itemBuilder: (context, index) {
          Response response = responses[index];

          return ListTile(title: Text(response.request.description), onTap: () {
            onResponse(response);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<Store>(context, rebuildOnChange: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Отклики'),
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey, child: buildList(), onRefresh: init),
    );
  }
}
