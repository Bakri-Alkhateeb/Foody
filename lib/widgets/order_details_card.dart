import 'package:flutter/material.dart';
import 'package:foody/screens/client/meals.dart';
import 'package:foody/utils/globalState.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// ignore: must_be_immutable
class OrderDetailsCard extends StatefulWidget {
  String clientName;
  int clientPhoneNumber;
  String orderDate;
  String orderTime;
  List<String> orderMeals = [];
  List<double> orderMealsPrices = [];

  static bool isMealsIdsEmpty = true;

  OrderDetailsCard(
      String clientName,
      int clientPhoneNumber,
      String orderDate,
      String orderTime,
      List<String> orderMeals,
      List<double> orderMealsPrices) {
    this.clientName = clientName;
    this.clientPhoneNumber = clientPhoneNumber;
    this.orderDate = orderDate;
    this.orderTime = orderTime;
    this.orderMeals = orderMeals;
    this.orderMealsPrices = orderMealsPrices;
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailsCardState(clientName, clientPhoneNumber, orderDate,
        orderTime, orderMeals, orderMealsPrices);
  }
}

class _OrderDetailsCardState extends State<OrderDetailsCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  String clientName;
  int clientPhoneNumber;
  String orderDate;
  String orderTime;
  List<String> orderMeals = [];
  List<double> orderMealsPrices = [];

  _OrderDetailsCardState(
      String clientName,
      int clientPhoneNumber,
      String orderDate,
      String orderTime,
      List<String> orderMeals,
      List<double> orderMealsPrices) {
    this.clientName = clientName;
    this.clientPhoneNumber = clientPhoneNumber;
    this.orderDate = orderDate;
    this.orderTime = orderTime;
    this.orderMeals = orderMeals;
    this.orderMealsPrices = orderMealsPrices;
  }

  // width = 411.4285714285714
  // height = 797.7142857142857

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              height: height - (height / 5.6979591836734692857142857142857),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'اسم الزبون: $clientName',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 39.885714285714285),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'رقم الهاتف: 0$clientPhoneNumber',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 39.885714285714285),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'تاريخ الطلب: $orderDate',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 39.885714285714285),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'وقت الطلب: $orderTime',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 39.885714285714285),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'الوجبات:',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 39.885714285714285),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: height / 2.2791836734693877142857142857143,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderMeals.length,
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                  border: index == orderMeals.length - 1
                                      ? null
                                      : Border(bottom: BorderSide(width: 2))),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  Text(
                                    '${orderMeals[index]}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                        height / 39.885714285714285),
                                  ),
                                  Text(
                                    '${orderMealsPrices[index]}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                        height / 39.885714285714285),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
