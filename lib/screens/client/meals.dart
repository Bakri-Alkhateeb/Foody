import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody/utils/globalState.dart';
import 'package:foody/widgets/meal_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Meals extends StatefulWidget {
  static List<int> mealsIds = [];

  Meals({Key key}) : super(key: key);

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final GlobalState _globalState = GlobalState.instance;
  List<String> mealsNames = [];
  List<String> mealsImages = [];
  List<int> mealsId = [];
  List<double> mealsPrice = [];
  String userId;
  String fullName;
  int count = 0;
  bool doneFetching = false;

  // width = 411.4285714285714
  // height = 797.7142857142857

  _MealsState() {
    userIdSetter();
    fetchMeals();
  }

  Future<void> userIdSetter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName');
    });
  }

  Future<void> _addBtn(String userId2) async {
    Meals.mealsIds.sort();
    if (!MealCard.isMealsIdsEmpty) {
      _globalState.set('mealsIds', Meals.mealsIds);
      Navigator.of(context).pushNamed('/cart');
    } else {
      setState(() {
        scaffoldState.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xffFFFFFF),
          content: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'الرجاء اختيار وجبة واحدة على الأقل',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000)),
              ),
            ],
          ),
        ));
      });
    }
  }

  Future<void> logOutBtn() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setString('token', null);
    Navigator.of(context).pushNamedAndRemoveUntil('/main', (Route <dynamic> route) => false);
  }

  void logOutConfirm(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Text('هل تريد تسجيل الخروج؟')
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("لا"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: new Text("نعم"),
              onPressed: logOutBtn,
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchMeals() async {
    await http.post(GlobalState.MEALS, body: {
      'restaurantId': _globalState.get('restaurantId').toString(),
    }).then((http.Response response) {
      setState(() {
        count = json.decode(response.body)['count'];
        mealsNames.clear();
        mealsImages.clear();
        mealsId.clear();
        mealsPrice.clear();
      });
      for (int i = 0; i < count; i++) {
        mealsNames.add(json.decode(response.body)['mealsNames'][i]);
        mealsImages.add(json.decode(response.body)['mealsImages'][i]);
        mealsId.add(json.decode(response.body)['mealsIds'][i]);
        mealsPrice.add(double.parse(
            json.decode(response.body)['mealsPrices'][i].toString()));
      }
    }).then((value) {
      setState(() {
        doneFetching = true;
      });
    });
  }

  Widget floatingAppBar({String title, Color color, Color textColor}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        width: width - 32,
        height: height / 14.503896103896103636363636363636,
        child: Stack(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Positioned(
              right: 10,
              child: InkWell(
                onTap: () => scaffoldState.currentState.openEndDrawer(),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: height / 46.924369747899158823529411764706,
                      right: height / 79.77142857142857),
                  child: Icon(
                    Icons.menu,
                    size: height / 31.908571428571428,
                    color: textColor,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: height / 39.885714285714285, color: textColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            key: scaffoldState,
            endDrawer: Drawer(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.black,
                    child: Center(
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            child:
                                Icon(Icons.chevron_right, color: Colors.white),
                            onTap: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      fullName != null ? fullName : "USER",
                      style: TextStyle(
                          fontSize: height / 39.885714285714285,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 0,
                    thickness: 2,
                  ),
                  Directionality(
                    child: InkWell(
                      child: ListTile(
                        title: Text(
                          "تسجيل خروج",
                          style: TextStyle(
                              fontSize: height / 39.885714285714285,
                              color: Colors.black),
                        ),
                        leading: Icon(Icons.exit_to_app),
                      ),
                      onTap: logOutConfirm,
                    ),
                    textDirection: TextDirection.rtl,
                  )
                ],
              ),
            ),
            backgroundColor: Colors.white,
            body: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: (height / 14.503896103896103636363636363636) + 25),
                    child: doneFetching
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: count,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) => MealCard(
                                mealsId[index],
                                mealsNames[index],
                                mealsPrice[index],
                                mealsImages[index],
                                index),
                          )
                        : Container(
                            child: Center(
                              child: Text(
                                "انتظر قليلاً",
                                style: TextStyle(
                                    fontSize: height / 26.59047619047619,
                                    color: Colors.grey),
                              ),
                            ),
                          )),
                floatingAppBar(
                    title: "الوجبات",
                    color: Color(0xff000000),
                    textColor: Color(0xffFFFFFF)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () => _addBtn(userId),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      width: width,
                      child: Text(
                        "متابعة",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: height / 26.59047619047619,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
