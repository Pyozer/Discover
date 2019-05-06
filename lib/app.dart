import 'package:discover/screens/home_screen.dart';
import 'package:discover/screens/login_screen.dart';
import 'package:discover/utils/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return LoginProvider(
      child: Builder(
        builder: (context) {
          bool isLogged = LoginProvider.of(context).isLogin();
          
          return MaterialApp(
            title: 'Discover',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: "WorkSans",
            ),
            home: isLogged ? HomeScreen() : LoginPage(),
          );
        },
      ),
    );
  }
}
