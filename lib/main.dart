import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody/screens/client/cart.dart';
import 'package:foody/screens/client/meals.dart';
import 'package:foody/screens/splash.dart';
import 'package:foody/screens/client/clientHome.dart';
import 'package:foody/screens/client/clientLogin.dart';
import 'package:foody/screens/client/clientSignUp.dart';
import 'package:foody/screens/client/restaurants.dart';
import 'package:foody/screens/manager/restaurantHome.dart';
import 'package:foody/screens/manager/restaurantLogin.dart';
import 'package:foody/screens/manager/restaurantSignUp.dart';
import 'package:foody/screens/home.dart';
import 'package:foody/screens/manager/orders.dart';
import 'package:foody/screens/manager/order_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isLoggedIn = false;
  bool isManager = false;

  void auth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      isLoggedIn = true;
      isManager = prefs.getBool('isManager');
    }else{
      isLoggedIn = false;
    }
  }

  MyApp(){
    auth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فودي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => Home(),
        '/home': (BuildContext context) => isLoggedIn ? isManager ? Orders() : Restaurants() : Home(),
        '/clientHome': (BuildContext context) => ClientHome(),
        '/restaurantHome': (BuildContext context) => RestaurantHome(),
        '/clientLogin': (BuildContext context) => ClientLogin(),
        '/clientSignUp': (BuildContext context) => ClientSignUp(),
        '/restaurantLogin': (BuildContext context) => RestaurantLogin(),
        '/restaurantSignUp': (BuildContext context) => RestaurantSignUp(),
        '/restaurants': (BuildContext context) => Restaurants(),
        '/meals': (BuildContext context) => Meals(),
        '/cart': (BuildContext context) => Cart(),
        '/orders': (BuildContext context) => Orders(),
        '/details': (BuildContext context) => OrderDetails(),
        '/splash': (BuildContext context) => Splash(),
      },
    );
  }
}
