import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/app_bar_text.dart';
import 'package:superhero_flutter/components/button.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/constants/roles.dart';
import 'package:superhero_flutter/constants/routes.dart';
import 'package:superhero_flutter/models/request.dart';
import 'package:superhero_flutter/models/response.dart';
import 'package:superhero_flutter/store.dart';

class DetailedRequestScreen extends StatefulWidget {
  @override
  DetailedRequestState createState() => DetailedRequestState();
}

class DetailedRequestState extends State<DetailedRequestScreen> {
  bool isLoading = false;

  confirmRequest() async {
    Store store = ScopedModel.of<Store>(context);

    try {
      await store.confirmRequest(store.detailedRequest.id);

      if (store.clientDetails.role == Roles.CUSTOMER) {
        store.detailedRequest.isFinishedByCustomer = true;
      } else if (store.clientDetails.role == Roles.CONTRACTOR) {
        store.detailedRequest.isFinishedByContractor = true;
      }
    } catch (e) {
      print(e);
    }
  }

  respond() async {
    await Navigator.of(context).pushNamed(Routes.CREATE_RESPONSE);
    this.init();
  }

  Widget field(String key, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(key),
          Text(value),
        ],
      ),
    );
  }

  Widget getTitle(String id) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text('Заявка №${id}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
    );
  }

  Widget getType(String type) {
    return Container(
      child: Text(type,
          style: TextStyle(
              fontSize: 16,
              color: AppColors.TEXT_COLOR,
              height: 1.2,
              fontWeight: FontWeight.w500)),
    );
  }

  Widget getAddress(String address) {
    return Container(
      child: Text(address,
          style: TextStyle(
              fontSize: 16, color: AppColors.TEXT_COLOR, height: 1.2)),
    );
  }

  Widget getResponseCount(String responseCount) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color.fromARGB(40, 0, 0, 0)))),
      padding: EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Text(
                      responseCount,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                      width: 70,
                      child: Opacity(
                        opacity: 0.9,
                        child: Text(
                          'откликов на заявку',
                          style: TextStyle(
                              color: AppColors.TEXT_COLOR,
                              fontSize: 14,
                              height: 0.9),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Opacity(opacity: 0.4, child: Icon(Icons.remove_red_eye, size: 26))
        ],
      ),
    );
  }

  Widget getPublicationDate(String publicationDate) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Text(publicationDate,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
    );
  }

  Widget getBottomRow(Request request) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          getBottomRowColumn('Срок окончания', request.expirationDate),
        ],
      ),
    );
  }

  Widget getBottomRowColumn(String name, String value) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text(name.toUpperCase(),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget getButton() {
    Store store = ScopedModel.of<Store>(context);

    // If the client is not contractor
    if (store.clientDetails.role != Roles.CONTRACTOR) {
      return null;
    }

    // If request already assigned
    if (store.detailedRequest.contractorId != null) {
      return null;
    }

    // If no responses
    if (store.responses == null) {
      return null;
    }

    bool responded = false;

    for (Response response in store.responses) {
      if (response.contractorId == store.clientDetails.id &&
          response.requestId == store.detailedRequest.id) {
        responded = true;
        break;
      }
    }

    if (responded) {
      return null;
    }

    // If responded
    return Button(
        text: 'Откликнуться',
        isLoading: false,
        onTap: () {
          respond();
        });
  }

  Widget getAttach(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Opacity(
            opacity: 0.4,
            child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.insert_drive_file)),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget getTechnicalInstructions(Request request) {
    List<Widget> children = List();

    children.add(getAttach('Технические условия'));

    if (request.contractorId != null) {
      children.add(getAttach('Проект'));
      children.add(getAttach('Однолинейная схема'));
      children.add(getAttach('Договор на работу'));
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(children: children),
    );
  }

  Widget requestPage() {
    Store store = ScopedModel.of<Store>(context);
    Request request = store.detailedRequest;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(10),
          elevation: 2,
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getPublicationDate(request.publishDate),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(40, 0, 0, 0)))),
                      padding: EdgeInsets.only(
                          left: 20, bottom: 20, right: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          getTitle(request.id.toString()),
                          getType(request.typeValue),
                          getAddress(request.address),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              getResponseCount(request.responseCount.toString()),
              getTechnicalInstructions(request)
            ],
          )),
        ),
        Container(padding: EdgeInsets.only(bottom: 20), child: getButton())
      ],
    );
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

  init() async {
    showLoader();

    Store store = ScopedModel.of<Store>(context);

    try {
      await store.fetchRequests();
      store.detailedRequest = store.requests.firstWhere(
          (Request request) => request.id == store.detailedRequest.id);
      await store.fetchResponses();
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
  }

  @override
  void initState() {
    super.initState();
    this.init();
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
          title: AppBarText(text: 'Информация'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : requestPage());
  }
}
