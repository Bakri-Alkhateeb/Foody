import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody/utils/globalState.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with SingleTickerProviderStateMixin {
  GlobalState _globalState = GlobalState.instance;
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  int userId;
  List<String> mealsNames = [];
  List<String> mealsImages = [];
  List<int> mealsIds = [];
  List<int> mealsQuantities = [];
  static Map<int, int> mealsQuantitiesMap = <int, int>{};
  double orderPrice;
  List<double> mealsPrices = [];
  int count;
  bool isCartEmpty = true;
  final _formKey = GlobalKey<FormState>();
  String fullName;
  bool doneFetching = false;
  TextEditingController location = new TextEditingController();
  final Location userLocation = Location();
  LocationData locationData;
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  String _error;
  bool gettingLocation = false;

  _CartState() {
    userIdSetter();
    fetchCart();
  }

  // width = 411.4285714285714
  // height = 797.7142857142857

  Future<void> logOutBtn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setString('token', null);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  }

  void logOutConfirm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[Text('هل تريد تسجيل الخروج؟')],
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

  Future<void> userIdSetter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName');
      userId = prefs.getInt('userId');
    });
  }

  void quantitiesArrayValuesSetter() {
    List<int> keys = mealsQuantitiesMap.keys.toList();
    mealsQuantities.clear();
    for (int i = 0; i < keys.length; i++) {
      setState(() {
        mealsQuantities.add(int.parse(mealsQuantitiesMap[keys[i]].toString()));
      });
    }
    calcSum();
  }

  void calcSum() {
    double sum = 0;
    orderPrice = 0.0;
    for (int i = 0; i < count; i++) {
      sum += mealsQuantitiesMap[mealsIds[i]] * mealsPrices[i];
    }
    setState(() {
      orderPrice = sum;
    });
  }

  Future<void> fetchCart() async {
    mealsIds = _globalState.get('mealsIds');

    await Future.forEach(mealsIds, (id) {
      http.post(GlobalState.CART, body: {'mealId': id.toString()}).then(
          (http.Response response) {
        if (response.statusCode == 201) {
          mealsNames.add(json.decode(response.body)['mealName']);
          mealsPrices.add(
              double.parse(json.decode(response.body)['mealPrice'].toString()));
          mealsImages.add(json.decode(response.body)['mealImage']);
        }
      }).then((value) {
        setState(() {
          doneFetching = true;
        });
      });
    });
  }

  Future<void> dismissObject(
      int id, String name, double price, String image) async {
    count--;
    mealsIds.remove(id);
    mealsNames.remove(name);
    mealsPrices.remove(price);
    mealsImages.remove(image);
    debugPrint('Dismissed');
    if (count == 0) {
      setState(() {
        count = 0;
      });
      emptyCartBtn();
    }
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await userLocation.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await userLocation.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      final LocationData _locationResult = await userLocation.getLocation();
      setState(() {
        locationData = _locationResult;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    }
  }

  Future<void> addOrder() async {
    debugPrint(locationData.toString());
    quantitiesArrayValuesSetter();
    http.post(GlobalState.ORDERS, body: {
      'mealsIds': mealsIds.toString(),
      'mealsPrices': mealsPrices.toString(),
      'ownerRestaurantId': _globalState.get('restaurantId').toString(),
      'orderLocation': location.text,
      'quantities': mealsQuantities.toString(),
      'orderPrice': orderPrice.toString(),
      'userId': userId.toString(),
      'lat': locationData.latitude.toString(),
      'long': locationData.longitude.toString()
    }).then((http.Response response2) {
      if (response2.statusCode == 201) {
        setState(() {
          gettingLocation = false;
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/restaurants', (route) => false);
      }
    });
  }

  void emptyCartBtn() {
    mealsIds = [];
    mealsNames = [];
    mealsPrices = [];
    mealsImages = [];
    setState(() {
      isCartEmpty = true;
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/restaurants', (route) => false);
  }

  void sendBtn() {
    if (_formKey.currentState.validate()) {
      setState(() {
        gettingLocation = true;
      });
      _requestPermission().then((value) {
        _requestService().then((value) {
          _getLocation().then((value) {
            addOrder();
          });
        });
      });
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
                'الرجاء إدخال جميع الكميات',
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

  Widget _foodList(int mealId, String mealName, double mealPrice,
      String mealImage, BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: <Widget>[
        Container(
          height: height / 7.977142857142857,
          width: width,
          child: _foodInfo(mealId, mealName, mealPrice, mealImage, context),
        ),
      ],
    );
  }

  Widget _card(String imgPath) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage("${GlobalState.MEALS_IMAGES}/$imgPath"),
          fit: BoxFit.fill,
        ),
      ),
      height: height / 10.636190476190476,
      width: width / 5.4857142857142853333333333333333,
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 5), blurRadius: 10, color: Color(0x12000000))
          ]),
    );
  }

  Widget _foodInfo(
      int id, String name, double price, String image, BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      height: height / 4.6924369747899158823529411764706,
      width: width - 20,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: _card(image),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: height / 7.977142857142857,
              child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Container(
                    child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    height / 46.924369747899158823529411764706,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 10)
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      SizedBox(width: 5),
                      Text(price.toString(),
                          style: TextStyle(
                              fontSize: height / 66.476190476190475,
                              color: Colors.black)),
                      SizedBox(width: 3),
                      Text('ل.س',
                          style: TextStyle(
                              fontSize: height / 66.476190476190475,
                              color: Colors.black)),
                    ],
                  )
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                width: width / 8.228571428571428,
                height: height / 13.295238095238095,
                child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      mealsQuantitiesMap[id] = int.parse(text);
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    enableInteractiveSelection: false,
                    expands: false,
                    enabled: true,
                    maxLength: 2,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: false,
                        hintText: '',
                        counterText: 'العدد',
                        counterStyle: TextStyle(
                            fontSize:
                                height / 61.362637362637361538461538461538,
                            fontWeight: FontWeight.bold),
                        hintStyle: TextStyle(color: Color(0xff000000)))),
              ),
            ],
          )
        ],
      ),
    );
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
            Positioned(
              left: 10,
              child: InkWell(
                onTap: emptyCartBtn,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: height / 46.924369747899158823529411764706,
                      right: height / 79.77142857142857),
                  child: Icon(
                    Icons.delete,
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

  Widget loadingLocation() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      color: Color(0xff000000).withOpacity(.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/locationLoading.gif',
              height: height / 15.954285714285714,
            ),
            SizedBox(height: height / 39.885714285714285),
            Text("جارٍ الحصول على موقعك",
                style: TextStyle(
                    color: Colors.white, fontSize: height / 39.885714285714285))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    setState(() {
      count = mealsIds.length;
    });
    return SafeArea(
      child: Scaffold(
          key: scaffoldState,
          backgroundColor: Colors.white,
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
                          child: Icon(Icons.chevron_right, color: Colors.white),
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
          body: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              doneFetching
                  ? Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: (height / 14.503896103896103636363636363636) +
                                25),
                        child: ListView.builder(
                            itemCount: count,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (DismissDirection direction) {
                                    dismissObject(
                                        mealsIds[index],
                                        mealsNames[index],
                                        mealsPrices[index],
                                        mealsImages[index]);
                                  },
                                  key: Key(mealsIds[index].toString()),
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child: Row(
                                      textDirection: TextDirection.ltr,
                                      children: <Widget>[
                                        SizedBox(width: 15),
                                        Icon(
                                          Icons.delete,
                                          color: Color(0xffffffff),
                                          size: height / 39.885714285714285,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: _foodList(
                                      mealsIds[index],
                                      mealsNames[index],
                                      mealsPrices[index],
                                      mealsImages[index],
                                      context));
                            }),
                      ),
                    )
                  : Center(
                      child: Container(
                        child: Text(
                          'انتظر قليلاً',
                          style: TextStyle(
                            color: Color(0xffAAAAAA),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              floatingAppBar(
                  title: "الطلبية",
                  color: Color(0xff000000),
                  textColor: Color(0xffFFFFFF)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: height / 15.954285714285714,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        RaisedButton(
                          color: Color(0xff000000),
                          onPressed: sendBtn,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              Container(
                                width: width - 32,
                                height: height / 15.954285714285714,
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      'إرسال',
                                      style: TextStyle(
                                          fontSize: height / 39.885714285714285,
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              gettingLocation
                  ? loadingLocation()
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ],
          )),
    );
  }
}
