import 'package:flutter/material.dart';
import 'package:foody/utils/globalState.dart';
import 'package:foody/widgets/bezierContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RestaurantLogin extends StatefulWidget {
  RestaurantLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RestaurantLoginState createState() => _RestaurantLoginState();
}

class _RestaurantLoginState extends State<RestaurantLogin> {
  // width  = 411.4285714285714
  // height = 797.7142857142857

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  GlobalState _globalState = GlobalState.instance;
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final passwordFocus = FocusNode();
  final usernameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!_formKey.currentState.validate()) {
      scaffoldState.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xff000000),
        content: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'رجاءً أدخل معلوماتك',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFFFFFF)),
            ),
          ],
        ),
      ));
    } else {
      http.post(GlobalState.LOGIN, body: {
        'username': username.text,
        'password': password.text,
        'isManager': 'true'
      }).then((http.Response response) async {
        if (response.statusCode == 201) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', json.decode(response.body)['token']);
          prefs.setString('username', json.decode(response.body)['username']);
          prefs.setString('password', json.decode(response.body)['password']);
          prefs.setInt('userId', json.decode(response.body)['id']);
          prefs.setInt('relatedRestaurantId', json.decode(response.body)['relatedRestaurantId']);
          prefs.setBool('isManager', true);
          username.text = '';
          password.text = '';
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/orders', (Route<dynamic> route) => false);
        } else {
          setState(() {
            scaffoldState.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xff000000),
              content: Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'اسم المستخدم خاطئ أو كلمة الرور خاطئة',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFFFFF)),
                  ),
                ],
              ),
            ));
          });
        }
      });
    }
  }

  Widget backButton() {
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('رجوع',
                style: TextStyle(
                    fontSize: height / 53.18095238095238,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Directionality(
            child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    if (isPassword)
                      return 'الرجاء إدخال كلمة المرور';
                    else
                      return 'الرجاء إدخال اسم المستخدم';
                  }
                  return null;
                },
                obscureText: isPassword,
                textInputAction:
                    isPassword ? TextInputAction.go : TextInputAction.next,
                onFieldSubmitted: (v) {
                  if (!isPassword)
                    FocusScope.of(context).requestFocus(passwordFocus);
                  else
                    login();
                },
                focusNode: isPassword ? passwordFocus : usernameFocus,
                controller: isPassword ? password : username,
                decoration: InputDecoration(
                    labelText: title,
                    border: OutlineInputBorder(),
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    );
  }

  Widget loginBtn() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () => login(),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: Colors.black),
        child: Text(
          'سجل دخولك',
          style: TextStyle(
              fontSize: height / 39.885714285714285, color: Colors.white),
        ),
      ),
    );
  }

  Widget title(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Text(
      'تسجيل الدخول',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: height / 26.59047619047619,
          fontWeight: FontWeight.bold,
          color: Color(0xff000000)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: scaffoldState,
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SizedBox(),
                    ),
                    title(context),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      autovalidate: false,
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          entryField("اسم المستخدم"),
                          entryField("كلمة المرور", isPassword: true),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    loginBtn(),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
              Positioned(top: 40, left: 0, child: backButton()),
              Positioned(
                  top: height / -6.6666666666666666666666666666667,
                  right: height / -4.8472222222222224720293209876543,
                  child: BezierContainer())
            ],
          ),
        )));
  }
}
