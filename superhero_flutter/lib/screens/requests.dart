import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
    } catch (error) {
      print(error);
    }
  }
  
  Widget buildList() {
    Store store = ScopedModel.of<Store>(context, rebuildOnChange: true);

    return ListView.builder(itemCount: store.requests != null ? store.requests.length : 0, itemBuilder: (context, index) {
      var request = store.requests[index];
      var description = request['description'];
      var expirationDate = request['expirationDate'];

      return ListTile(leading: Icon(Icons.description), title: Text(description), subtitle: Text(expirationDate), onTap: () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ScopedModelDescendant<Store>(builder: (context, child, store) {
        String title = 'Заявки (' + (store.requests != null ? store.requests.length : 0).toString() + ')';
        return Text(title);
      })),
        body: RefreshIndicator(key: _refreshIndicatorKey, child: buildList(), onRefresh: init)
    );
  }
}
