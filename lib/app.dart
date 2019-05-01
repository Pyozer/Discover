import 'package:discover/screens/home_screen.dart';
import 'package:discover/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      title: 'Discover',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "WorkSans"),
      home: LoginPage(),
    );
  }
}
