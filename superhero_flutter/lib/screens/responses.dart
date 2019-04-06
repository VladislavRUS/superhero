import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/constants/roles.dart';
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
    super.initState();
    init();
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

          return getListItem(response);
        });
  }

  Widget getListItem(Response response) {
    return Material(
      color: Colors.white,
      child: InkWell(
          onTap: () {
            onListItemTap(response);
          },
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color.fromARGB(60, 0, 0, 0)))),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              child: buildListItemChild(response))),
    );
  }

  onListItemTap(Response response) {
    Store store = ScopedModel.of<Store>(context);

    store.currentResponse = response;

    Navigator.of(context).pushNamed(Routes.MESSAGES);
  }

  Widget getTitle(Response response) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromARGB(50, 0, 0, 0),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Center(
        child: Text(
          '#${response.requestId}',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget buildListItemChild(Response response) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  child: Row(
            children: <Widget>[getTitle(response), getInfo(response)],
          ))),
          Icon(Icons.chevron_right)
        ],
      ),
    );
  }

  Widget getInfo(Response response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[getName(response)],
    );
  }

  Widget getName(Response response) {
    Store store = ScopedModel.of<Store>(context);

    if (store.clientDetails.role == Roles.CUSTOMER) {
      if (response.contractorDetails.isLegalEntity) {
        return nameText(response.contractorDetails.companyName);
      } else {
        return nameText(response.contractorDetails.fullName);
      }
    } else if (store.clientDetails.role == Roles.CONTRACTOR) {
      return nameText('Заказчик №${response.request.customerId}');
    }

    return nameText('');
  }

  Widget nameText(String text) {
    return Container(child: Text(text, style: TextStyle(fontSize: 16)));
  }

  Widget getLastMessage(Response response) {
    return Container(
      child: Opacity(
        opacity: 0.7,
        child: Text('Не могли бы вы подъехать...',
            style: TextStyle(
                fontSize: 14, color: AppColors.TEXT_COLOR, height: 1.2)),
      ),
    );
  }

  Widget getContractorName(Response response) {
    return Container(
      child: Text('ООО Ромашка',
          style: TextStyle(
              fontSize: 14, color: AppColors.TEXT_COLOR, height: 1.2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<Store>(context, rebuildOnChange: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        title: AppBarText(text: 'Отклики'),
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey, child: buildList(), onRefresh: init),
    );
  }
}
