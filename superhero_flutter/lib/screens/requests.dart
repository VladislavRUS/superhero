import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      await ScopedModel.of<Store>(context).fetchRequests();
    } catch (e) {
      print(e);
    }
  }

  Widget buildList() {
    var requests =
        ScopedModel.of<Store>(context, rebuildOnChange: true).requests;

    return ListView.builder(
        itemCount: requests != null ? requests.length : 0,
        itemBuilder: (context, index) {
          var request = requests[index];
          var description = request.description;
          var expirationDate = request.expirationDate;
          var responseCount = request.responseCount;
          var isConfirmed = request.isConfirmed;

          return ListTile(
              leading: Icon(
                Icons.description,
                color: isConfirmed ? Colors.green : Colors.grey,
              ),
              title: Text(description),
              trailing: Text(responseCount.toString()),
              subtitle: Text(expirationDate.toString()),
              onTap: () {
                onListTileTap(requests[index]);
              });
        });
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

  canSeeActionButton(String role) {
    if (role == Roles.CUSTOMER) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    Store store = ScopedModel.of(context);
    String role = store.role;
    bool isActionButtonAvailable = canSeeActionButton(role);

    return Scaffold(
      appBar: AppBar(
          title: ScopedModelDescendant<Store>(builder: (context, child, store) {
        String title = 'Заявки';
        return Text(title);
      })),
      body: RefreshIndicator(
          key: _refreshIndicatorKey, child: buildList(), onRefresh: init),
      floatingActionButton: isActionButtonAvailable
          ? FloatingActionButton(
              onPressed: addRequest,
              child: Center(
                child: Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}
