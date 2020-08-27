import 'package:flutter/material.dart';
import 'package:foody/utils/globalState.dart';

// ignore: must_be_immutable
class OrderCard extends StatefulWidget {
  int orderId;

  OrderCard(int orderId) {
    this.orderId = orderId;
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderCardState(orderId);
  }
}

class _OrderCardState extends State<OrderCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  int orderId;
  final GlobalState _globalState = GlobalState.instance;

  _OrderCardState(int orderId) {
    this.orderId = orderId;
  }

  // width = 411.4285714285714
  // height = 797.7142857142857

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        _globalState.set('orderId', orderId);
        Navigator.of(context).pushNamed('/details');
      },
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
                height: height / 7.977142857142857,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Center(
                      child: Text(
                        orderId.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height / 39.885714285714285),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
