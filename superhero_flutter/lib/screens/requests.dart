import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/constants/roles.dart';
import 'package:superhero_flutter/constants/routes.dart';
import 'package:superhero_flutter/models/request.dart';
import 'package:superhero_flutter/store.dart';

class RequestsScreen extends StatefulWidget {
  @override
  RequestsScreenState createState() => RequestsScreenState();
}

class RequestsScreenState extends State<RequestsScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Store store;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    try {
      await ScopedModel.of<Store>(context).fetchRequests();
    } catch (e) {
      print(e);
    }
  }

  Widget buildList() {
    var requests = ScopedModel.of<Store>(context).requests;

    return ListView.builder(
        itemCount: requests != null ? requests.length : 0,
        itemBuilder: (context, index) {
          var request = requests[index];
          bool isLast = index == requests.length - 1;
          return getListItem(request, isLast);
        });
  }

  Widget getTitle(String text) {
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Text(text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_COLOR)));
  }

  Widget getBudget(int budget) {
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Text(budget.toString() + ' тыс.',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.TEXT_COLOR)));
  }

  Widget getExpirationDate(String expirationDate) {
    return Opacity(
      opacity: 0.7,
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(expirationDate,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.TEXT_COLOR))),
    );
  }

  Widget getDescription(String description) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text(description,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.TEXT_COLOR)));
  }

  Widget getPublishDate(String publishDate) {
    return Opacity(
      opacity: 0.7,
      child: Container(
          child: Text(publishDate,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.TEXT_COLOR))),
    );
  }

  Widget getListItem(Request request, bool isLast) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: isLast
                      ? BorderSide.none
                      : BorderSide(
                          color: Color.fromARGB(60, 0, 0, 0), width: 1))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getTitle(request.title),
                    getBudget(request.budget),
                    getExpirationDate(request.expirationDate),
                    getDescription(request.description),
                    getPublishDate(request.publishDate)
                  ],
                ),
              ),
              Container(
                width: 20,
                margin: EdgeInsets.only(left: 10),
                child: Opacity(
                  opacity: 0.7,
                  child: Column(
                    children: <Widget>[Icon(Icons.chevron_right)],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onListTileTap(Request request) async {
    ScopedModel.of<Store>(context).setDetailedRequest(request);
    await Navigator.pushNamed(context, Routes.DETAILED_REQUEST);
    init();
  }

  addRequest() async {
    await Navigator.pushNamed(context, Routes.CREATE_REQUEST);
    init();
  }

  canAddRequest() {
    Store store = ScopedModel.of<Store>(context);

    if (store.clientDetails.role == Roles.CUSTOMER) {
      return true;
    }

    return false;
  }

  List<Widget> getActions() {
    List<Widget> actions = List();

    if (canAddRequest()) {
      actions.add(IconButton(
          onPressed: addRequest,
          icon: Icon(
            Icons.add,
            color: AppColors.TEXT_COLOR,
          )));
    }

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<Store>(context, rebuildOnChange: true);

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
          actions: getActions(),
          title: AppBarText(text: 'Заявки'),
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: RefreshIndicator(
          key: _refreshIndicatorKey, child: buildList(), onRefresh: init),
    );
  }
}
