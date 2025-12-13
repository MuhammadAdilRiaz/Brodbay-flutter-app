import 'package:brodbay/screens/Cart/cart_screen.dart';
import 'package:brodbay/screens/home/home.dart';
import 'package:brodbay/screens/splash%20screen/splash_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String cart = '/cart';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    cart: (context) => const CartScreen(),
  };
}
