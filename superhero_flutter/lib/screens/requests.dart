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

  Widget getTitle(String id) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text('Заявка №${id}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_COLOR)));
  }

  Widget getBudget(int budget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 7),
            child: Opacity(
                opacity: 0.4, child: Icon(Icons.monetization_on, size: 18))),
        Opacity(
          opacity: 0.7,
          child: Container(
              child: Text(budget.toString() + ' тыс. руб',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.TEXT_COLOR))),
        ),
      ],
    );
  }

  Widget getInfo(Request request) {
    String infoText;

    if (request.customerDetails.isLegalEntity) {
      infoText = request.customerDetails.companyName;
    } else {
      infoText = request.customerDetails.fullName;
    }

    return Opacity(
      opacity: 0.7,
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(infoText,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.TEXT_COLOR))),
    );
  }

  Widget getTypeValue(String typeValue) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Opacity(
          opacity: 0.85,
          child: Text(typeValue,
              style: TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                  color: AppColors.TEXT_COLOR)),
        ));
  }

  Widget getAddress(String address) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Opacity(
          opacity: 0.85,
          child: Text(address,
              style: TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                  color: AppColors.TEXT_COLOR)),
        ));
  }

  Widget getPublishDate(String publishDate) {
    return Row(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Container(
            margin: EdgeInsets.only(right: 7),
            child: Icon(
              Icons.access_time,
              size: 16,
            ),
          ),
        ),
        Opacity(
          opacity: 0.7,
          child: Container(
              child: Text(publishDate,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.TEXT_COLOR))),
        ),
      ],
    );
  }

  Widget getListItem(Request request, bool isLast) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          onListTileTap(request);
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
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
                    getTitle(request.id.toString()),
                    getTypeValue(request.typeValue),
                    getAddress(request.address),
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
                    children: <Widget>[
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                      )
                    ],
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

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<Store>(context, rebuildOnChange: true);

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
          title: AppBarText(text: 'Заявки'),
          elevation: 0.3,
          backgroundColor: Colors.white),
      body: RefreshIndicator(
          key: _refreshIndicatorKey, child: buildList(), onRefresh: init),
    );
  }
}
