import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/components/button.dart';
import 'package:superhero_flutter/components/input.dart';
import 'package:superhero_flutter/constants/app_colors.dart';
import 'package:superhero_flutter/constants/routes.dart';
import 'package:superhero_flutter/store.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    emailTextEditingController.text = 'contractor';
    passwordTextEditingController.text = 'contractor';
    super.initState();
  }

  void onLogin() async {
    showLoader();

    await Future.delayed(Duration(milliseconds: 500));

    String email = emailTextEditingController.text;
    String password = passwordTextEditingController.text;

    try {
      await ScopedModel.of<Store>(context).login(email, password);
      Navigator.pushReplacementNamed(context, Routes.APP);
    } catch (e) {
      print(e);
    } finally {
      hideLoader();
    }
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

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.MAIN_COLOR,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Card(
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Image.asset('assets/logo.png')),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Input(controller: emailTextEditingController),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Input(controller: passwordTextEditingController),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Button(
                        text: 'Войти',
                        onTap: onLogin,
                        isLoading: isLoading,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
