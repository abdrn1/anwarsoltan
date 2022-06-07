import 'package:anwar_alsultan/ui/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _loadSplash();
  }

  _loadSplash() {
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'lightning',
          child: SvgPicture.asset(
            'assets/images/lightning_splash.svg',
          ),
        ),
      ),
    );
  }
}
