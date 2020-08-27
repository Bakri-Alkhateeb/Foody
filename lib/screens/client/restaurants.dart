import 'package:flutter/material.dart';
import 'package:foody/utils/globalState.dart';
import 'package:foody/widgets/restaurant_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Restaurants extends StatefulWidget {
  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  // width = 411.4285714285714
  // height = 797.7142857142857

  List<String> restaurantsNames = [];
  List<String> restaurantsLocations = [];
  List<String> restaurantsImages = [];
  List<double> restaurantsRatings = [];
  List<int> restaurantsIds = [];
  int count;
  bool doneFetching = false;
  String fullName;

  Future<void> userIdSetter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName');
    });
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

  Future<void> fetchRestaurants() async {
    http.get(GlobalState.RESTAURANTS).then((http.Response response) {
      if (response.statusCode == 201) {
        setState(() {
          count = json.decode(response.body)['count'];
          restaurantsIds.clear();
          restaurantsNames.clear();
          restaurantsImages.clear();
          restaurantsLocations.clear();
          restaurantsRatings.clear();
        });
        for (int i = 0; i < count; i++) {
          restaurantsIds.add(json.decode(response.body)['restaurantsIds'][i]);
          restaurantsNames
              .add(json.decode(response.body)['restaurantsNames'][i]);
          restaurantsImages
              .add(json.decode(response.body)['restaurantsImages'][i]);
          restaurantsLocations
              .add(json.decode(response.body)['restaurantsLocations'][i]);
          restaurantsRatings
              .add(json.decode(response.body)['restaurantsRatings'][i]);
        }
      }
    }).then((value) {
      setState(() {
        doneFetching = true;
      });
    });
  }

  _RestaurantsState() {
    userIdSetter();
    fetchRestaurants();
  }

  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

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

    return SafeArea(
        child: Scaffold(
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
            key: scaffoldState,
            backgroundColor: Colors.white,
            body: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: (height / 14.503896103896103636363636363636) + 25),
                  child: doneFetching
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => RestaurantCard(
                            restaurantsIds[index],
                            restaurantsNames[index],
                            restaurantsLocations[index],
                            restaurantsImages[index],
                            restaurantsRatings[index].toString(),
                          ),
                          itemCount: count,
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
                        ),
                ),
                floatingAppBar(
                    title: "المطاعم",
                    color: Color(0xff000000),
                    textColor: Color(0xffFFFFFF)),
              ],
            )));
  }
}
