import 'package:flutter/material.dart';

class RestaurantHome extends StatefulWidget {
  @override
  _RestaurantHomeState createState() => _RestaurantHomeState();
}

class _RestaurantHomeState extends State<RestaurantHome>{

  // width = 411.4285714285714
  // height = 797.7142857142857

  Widget loginBtn(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/restaurantLogin'),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(500)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xff000000),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2
              )
            ],
            color: Color(0xff000000)
        ),
        child: Text(
          'تسجيل الدخول',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: height / 31.908571428571428,
              color: Color(0xffFFFFFF)
          ),
        ),
      ),
    );
  }

  Widget signUpBtn(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/restaurantSignUp'),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(500)),
          border: Border.all(
              color: Color(0xff000000),
              width: 2
          ),
        ),
        child: Text(
          'إنشاء حساب جديد',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: height / 31.908571428571428,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000)
          ),
        ),
      ),
    );
  }

  Widget title(BuildContext context) {

    var height = MediaQuery.of(context).size.height;

    return Text(
      'أهلاً بك',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: height / 15.954285714285714,
          fontWeight: FontWeight.bold,
          color: Colors.white
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body:SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2
                )
              ],
              color: Colors.black.withOpacity(.7)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              title(context),
              SizedBox(
                height: height / 9.97142857142857125,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xff000000).withAlpha(100),
                          offset: Offset(2, 4),
                          blurRadius: 8,
                          spreadRadius: 2
                      )
                    ]
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height / 39.885714285714285,
                    ),
                    Text(
                      'ماذا تريد؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: height / 19.9428571428571425,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000)
                      ),
                    ),
                    SizedBox(
                      height: height / 9.97142857142857125,
                    ),
                    loginBtn(context),
                    SizedBox(
                      height: height / 39.885714285714285,
                    ),
                    signUpBtn(context),
                    SizedBox(
                      height: height / 39.885714285714285,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
