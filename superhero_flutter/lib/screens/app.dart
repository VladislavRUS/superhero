import 'package:flutter/material.dart';
import 'package:superhero_flutter/screens/profile.dart';
import 'package:superhero_flutter/screens/requests.dart';
import 'package:superhero_flutter/screens/responses.dart';
import 'package:superhero_flutter/screens/settings.dart';

class AppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppScreenState();
  }
}

class AppScreenState extends State<AppScreen> {
  int screenIndex = 0;
  List<Widget> screens = [
    RequestsScreen(),
    ResponsesScreen(),
    ProfileScreen(),
    SettingsScreen()
  ];

  Widget bottomBarButton(
      IconData iconData, String text, Function onTap, bool active) {
    return Expanded(
      flex: 1,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                color:
                    active ? Colors.blue : Color.fromARGB(255, 118, 127, 157),
              ),
              Text(
                text,
                style: TextStyle(
                  color:
                      active ? Colors.blue : Color.fromARGB(255, 118, 127, 157),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      bottomBarButton(
          Icons.search, 'Заявки', () => setScreenIndex(0), isActiveScreen(0)),
      bottomBarButton(
          Icons.email, 'Отклики', () => setScreenIndex(1), isActiveScreen(1)),
      bottomBarButton(
          Icons.person, 'Профиль', () => setScreenIndex(2), isActiveScreen(2)),
      bottomBarButton(Icons.settings, 'Настройки', () => setScreenIndex(3),
          isActiveScreen(3)),
    ]);
  }

  setScreenIndex(int idx) {
    setState(() {
      screenIndex = idx;
    });
  }

  isActiveScreen(int idx) {
    return screenIndex == idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[screenIndex],
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: getRow(),
        ),
      ),
    );
  }
}
