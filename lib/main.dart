import 'package:flutter/material.dart';
import 'package:tampee_admin/screens/splash_screen.dart';
import 'package:tampee_admin/utils/common.dart';

void main() {
    runApp(MaterialApp(
    routes: {
    '/': (context) => SplashScreen(),
    //'/signin': (context) => SignIn("finish"),
    },
    theme: ThemeData(fontFamily: 'proxima',
  primaryColor: primaryColor,accentColor: primaryColor),
  ));
}
