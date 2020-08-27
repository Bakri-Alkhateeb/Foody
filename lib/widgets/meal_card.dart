import 'package:flutter/material.dart';
import 'package:foody/screens/client/meals.dart';
import 'package:foody/utils/globalState.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// ignore: must_be_immutable
class MealCard extends StatefulWidget {
  String mealName;
  double mealPrice;
  String mealImage;
  int mealId;
  int index;

  static bool isMealsIdsEmpty = true;

  MealCard(int mealId, String mealName, double mealPrice, String mealImage,
      int index) {
    this.mealName = mealName;
    this.mealPrice = mealPrice;
    this.mealImage = mealImage;
    this.mealId = mealId;
    this.index = index;
  }

  @override
  State<StatefulWidget> createState() {
    return _MealCardState(mealId, mealName, mealPrice, mealImage, index);
  }
}

class _MealCardState extends State<MealCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  double mealPrice;
  String mealImage;
  String mealName;
  double width;
  int mealId;
  int refResId;
  final GlobalState _globalState = GlobalState.instance;
  int mealsCount = 0;
  List<int> mealsId = [];
  int index;
  String userId;
  bool checkBoxValue = false;

  _MealCardState(int mealId, String mealName, double mealPrice,
      String mealImage, int index) {
    this.mealPrice = mealPrice;
    this.mealImage = mealImage;
    this.mealName = mealName;
    this.index = index;
    this.mealId = mealId;
  }

  // width = 411.4285714285714
  // height = 797.7142857142857

  void checkBoxValueChanger(bool value) {
    setState(() {
      checkBoxValue = value;
    });
    if (checkBoxValue) {
      if (!Meals.mealsIds.contains(mealId)) {
        setState(() {
          MealCard.isMealsIdsEmpty = false;
        });
        Meals.mealsIds.add(mealId);
      }
    } else {
      if (Meals.mealsIds.contains(mealId)) {
        if (Meals.mealsIds.length == 1) {
          MealCard.isMealsIdsEmpty = true;
        }
        Meals.mealsIds.remove(mealId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    var _width = MediaQuery.of(context).size.width / 2;
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () => setState(() {
            checkBoxValue = !checkBoxValue;
            checkBoxValueChanger(checkBoxValue);
          }),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: _width,
                    height: _width - 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage(
                        image: NetworkImage("${GlobalState.MEALS_IMAGES}/$mealImage"),
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/loading.gif'),
                      ),
                    ),
                  ),
                ),
                Text(
                  mealName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Checkbox(
              value: checkBoxValue,
              onChanged: checkBoxValueChanger,
              checkColor: Color(0xffFFFFFF),
              activeColor: Color(0xff000000),
            )
          ],
        )
      ],
    );
  }
}
