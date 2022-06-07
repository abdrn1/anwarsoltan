import 'package:anwar_alsultan/ui/view/chooser_screen.dart';
import 'package:anwar_alsultan/ui/view/collect/collect_screen.dart';
import 'package:anwar_alsultan/ui/view/home/home_screen.dart';
import 'package:anwar_alsultan/ui/view/login/login_screen.dart';
import 'package:anwar_alsultan/ui/view/read/read_screen.dart';
import 'package:anwar_alsultan/ui/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';

var customRoutes = <String, WidgetBuilder>{
  '/': (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  ChooserScreen.routeName: (context) => ChooserScreen(),
  HomeScreen.routeName: (context) => HomeScreen(0),
  ReadScreen.routeName: (context) => ReadScreen(),
  CollectScreen.routeName: (context) => CollectScreen(),
};
