import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:superhero_flutter/store.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailTextEditingController.text = 'admin';
    passwordTextEditingController.text = 'admin';
  }

  void onEmailChange(text) {
    emailTextEditingController.text = text;
  }

  void onPasswordChange(text) {
    passwordTextEditingController.text = text;
  }

  void onSubmit() async {
    showLoader();

    String email = emailTextEditingController.text;
    String password = passwordTextEditingController.text;

    try {
      await ScopedModel.of<Store>(context).login(email, password);
      Navigator.pushReplacementNamed(context, '/requests');
    } catch (e){
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading ? CircularProgressIndicator() : Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailTextEditingController,
                  decoration: InputDecoration.collapsed(hintText: 'Email'),
                  onChanged: onEmailChange,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordTextEditingController,
                  decoration: InputDecoration.collapsed(hintText: 'Пароль'),
                  onChanged: onPasswordChange,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: RaisedButton(onPressed: onSubmit, child: Text('Войти'),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
