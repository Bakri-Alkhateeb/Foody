import 'package:foody/utils/globalState.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:foody/widgets/bezierContainer.dart';

class RestaurantSignUp extends StatefulWidget {
  RestaurantSignUp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RestaurantSignUpState createState() => _RestaurantSignUpState();
}

class _RestaurantSignUpState extends State<RestaurantSignUp> {
  // width  = 411.4285714285714
  // height = 797.7142857142857

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController passwordConfirm = new TextEditingController();
  TextEditingController restaurantName = new TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();
  final usernameFocus = FocusNode();
  final restaurantNameFocus = FocusNode();

  Future<void> signUp() async {
    if (!_formKey.currentState.validate()) {
      scaffoldState.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 1500),
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
      if(passwordConfirm.text == password.text){
        http.post(GlobalState.SIGN_UP, body: {
          'username': username.text,
          'password': password.text,
          'isManager': 'true',
          'relatedRestaurantName': restaurantName.text
        }).then((http.Response response) async {
          if (response.statusCode == 201) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/restaurantLogin', (route) => false);
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
      }else{
        scaffoldState.currentState.showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: Color(0xff000000),
          content: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'كلمات السر ليست متطابقة',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFFFFFF)),
              ),
            ],
          ),
        ));
      }
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

  Widget entryField(
    String title, {
    bool isPassword = false,
    bool isPasswordConfirm = false,
    bool isRestaurantName = false,
  }) {
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
                    else if (isPasswordConfirm)
                      return 'الرجاء إدخال كلمة المرور مرة ثانية';
                    else if (isRestaurantName)
                      return 'الرجاء إدخال اسم مطعمك';
                    else
                      return 'الرجاء إدخال اسم المستخدم';
                  }
                  return null;
                },
                obscureText: isPassword || isPasswordConfirm,
                textInputAction: isPasswordConfirm
                    ? TextInputAction.go
                    : TextInputAction.next,
                onFieldSubmitted: (v) {
                  if (isPassword)
                    FocusScope.of(context).requestFocus(confirmPasswordFocus);
                  else if (isRestaurantName)
                    FocusScope.of(context).requestFocus(usernameFocus);
                  else if (isPasswordConfirm)
                    signUp();
                  else
                    FocusScope.of(context).requestFocus(passwordFocus);
                },
                focusNode: isPassword
                    ? passwordFocus
                    : isRestaurantName
                        ? restaurantNameFocus
                        : isPasswordConfirm
                            ? confirmPasswordFocus
                            : usernameFocus,
                controller: isPassword
                    ? password
                    : isRestaurantName
                        ? restaurantName
                        : isPasswordConfirm ? passwordConfirm : username,
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

  Widget signUpBtn() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () => signUp(),
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
          'أنشئ حسابك',
          style: TextStyle(
              fontSize: height / 39.885714285714285, color: Colors.white),
        ),
      ),
    );
  }

  Widget title(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Text(
      'تسجيل حساب جديد',
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
              child: ListView(
                children: <Widget>[
                  SizedBox(height: height / 5.1465437788018432258064516129032),
                  title(context),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    autovalidate: false,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        entryField("اسم المطعم", isRestaurantName: true),
                        entryField("اسم المستخدم"),
                        entryField("كلمة المرور", isPassword: true),
                        entryField("تأكيد كلمة المرور",
                            isPasswordConfirm: true),
                        //buildGridView()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  signUpBtn(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Positioned(top: 40, left: 0, child: backButton()),
            Positioned(
                top: height / -6.6666666666666666666666666666667,
                right: height / -4.8472222222222224720293209876543,
                child: BezierContainer()),
          ],
        ),
      )),
    );
  }
}
