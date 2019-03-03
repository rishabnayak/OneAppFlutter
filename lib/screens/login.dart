import 'package:HackRU/admin.dart';
import 'package:HackRU/models.dart';
import 'package:HackRU/screens/home.dart';
import 'package:HackRU/screens/scanner2.dart';
import 'package:HackRU/test.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/main.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:HackRU/hackru_service.dart';

class Login extends StatelessWidget {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _inputIsValid = true;

  final formKey = new GlobalKey<FormState>();

  checkFields(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  loginUser(){
    login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 30.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/hackru_circle_logo.png', width: 150, height: 150,),
                SizedBox(height: 5.0),
                Text('SPRING 2019',
                  style: TextStyle(color: green_tab, fontSize: 25),
                ),
              ],
            ),
            SizedBox(height: 35.0),
            Center(
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20, color: bluegrey),
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  fillColor: bluegrey,
                  hasFloatingPlaceholder: true,
                  errorText: _inputIsValid ? null : 'Please enter valid email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            Center(
              child: TextField(
                style: TextStyle(fontSize: 20, color: bluegrey),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  fillColor: bluegrey,
                  hasFloatingPlaceholder: true,
                  errorText: _inputIsValid ? null : 'Please enter valid password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
//                OutlineButton(
//                    child: Text('CANCEL'),
//                    textColor: bluegrey,
//                    shape: BeveledRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
//                    ),
//                    onPressed: (){
//                      _emailController.clear();
//                      _passwordController.clear();
//                      Navigator.pop(context, 'Cancel');
//                    }),
                RaisedButton(
                  child: Text('LOGIN'),
                  color: pink_dark,
                  textColor: white,
                  textTheme: ButtonTextTheme.normal,
                  elevation: 6.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                  onPressed: () async {
                    // Show a dialog with a loading animation
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context, {barrierDismissible: false}){
                        return new AlertDialog(backgroundColor: bluegrey_dark,
                          title: Center(
                            child: new CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(mintgreen_light), strokeWidth: 3.0,),
                          ),
                        );
                      }
                    );
                    try {
                      var cred = await login(_emailController.text, _passwordController.text);
                      var user = await getUser(cred, _emailController.text);
                      QRScanner2.cred = cred;
                      Home.userEmail = _emailController.text;
                      QRScanner2.userEmail = _emailController.text;
                      QRScanner2.userPassword = _passwordController.text;
                      print(user);
                      // Dismiss the loading dialog
                      Navigator.pop(context);
                      if(user.role["director"] == true ){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()),);
                      }
                      else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
                      }
                    } on LcsLoginFailed catch (e) {
                      // Dismiss the loading dialog
                      Navigator.pop(context);
                      showDialog<void>(context: context, barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(backgroundColor: bluegrey_dark,
                            title: Text("ERROR: \n'"+LcsLoginFailed().toString()+"'",
                              style: TextStyle(fontSize: 16, color: pink_light),),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK', style: TextStyle(fontSize: 16, color: mintgreen_dark),),
                                onPressed: () {Navigator.pop(context, 'Ok');},
                              ),
                            ],
                          );
                        },
                      );
                    }
                    _emailController.clear();
                    _passwordController.clear();
                  },
                ),
              ],
            ),
            SizedBox(height: 60.0,),
//            Text('** Not for Hackers!', style: TextStyle(color: pink_dark, fontSize: 12.0, fontWeight: FontWeight.w700),),
//            Text('Test Access: (g@g.com) (g)', style: TextStyle(color: bluegrey_dark, fontSize: 12.0),),
          ],
        ),
      ),
    );
  }

}


