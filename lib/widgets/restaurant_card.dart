import 'package:flutter/material.dart';
import 'package:foody/utils/globalState.dart';

// ignore: must_be_immutable
class RestaurantCard extends StatefulWidget {

  String name, location, imgPath, rating;
int resId;

  RestaurantCard(int resId, String name, String location, String imgPath, String rating){
    this.resId = resId;
    this.name = name;
    this.location = location;
    this.imgPath = imgPath;
    this.rating = rating;
  }

  @override
  _RestaurantCardState createState() => _RestaurantCardState(
    resId,
      name,
      location,
      imgPath,
      rating
  );
}

class _RestaurantCardState extends State<RestaurantCard>{

  // width = 411.4285714285714
  // height = 797.7142857142857

  String name, location, imgPath, rating;
  int resId;

  GlobalState _globalState = GlobalState.instance;

  _RestaurantCardState(this.resId, this.name, this.location, this.imgPath, this.rating);

  void restaurantBtn() {
    _globalState.set('restaurantId', resId);
    Navigator.of(context).pushNamed('/meals');
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: restaurantBtn,
      child: Card(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(10)
            ),
            height: height / 2.4545054945054944615384615384615 + 2,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    FadeInImage(
                      placeholder: AssetImage('assets/loading.gif'),
                      image: NetworkImage("${GlobalState.RESTAURANTS_IMAGES}/$imgPath"),
                      fit: BoxFit.fill,
                      width: width,
                      height: height / 3.2,
                    ),
                    Positioned(
                      top: 15,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: width / 7.48051948051948 + 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellowAccent,
                            ),
                            Text(
                              rating,
                              style: TextStyle(
                                  color: Colors.black
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: height / 36.259740259740259090909090909091
                            ),
                          ),
                        ],
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            location,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: height / 44.317460317460316666666666666667,
                                color: Colors.grey
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
