class GlobalState{
  static const SERVER = 'http://192.168.1.38:3000/';
  static const LOGIN = '${SERVER}login';
  static const SIGN_UP = '${SERVER}signup';
  static const RESTAURANTS = '${SERVER}restaurants';
  static const MEALS = '${SERVER}meals';
  static const ORDERS = '${SERVER}orders';
  static const CART = '${SERVER}cart';
  static const MEALS_INSERT = '${SERVER}mealsInsert';
  static const RESTAURANTS_INSERT = '${SERVER}restaurantsInsert';
  static const RESTAURANTS_IMAGES = '${SERVER}restaurantsImages';
  static const RECEIVED_ORDERS = '${SERVER}receivedOrders';
  static const RESTAURANT_NAME_SETTER = '${SERVER}restaurantNameSetter';
  static const MEALS_IMAGES = '${SERVER}mealsImages';
  static const FETCH_CLIENT_INFO = '${SERVER}fetchClientInfo';
  static const FETCH_ORDER_INFO = '${SERVER}fetchOrderInfo';
  static const FETCH_ORDER_MEALS = '${SERVER}fetchOrderMeals';
  final Map<String, dynamic> _data = <String, dynamic>{};
  static GlobalState instance = new GlobalState._();


  GlobalState._();

  set(String key, dynamic value) => _data[key] = value;
  get(String key) => _data[key];
}