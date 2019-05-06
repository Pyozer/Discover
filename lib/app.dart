import 'package:discover/screens/splash_screen.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  final SharedPreferences prefs;

  const App({Key key, this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return PreferencesProvider(
      prefs: prefs,
      child: Builder(
        builder: (context) {
          PreferencesProvider.of(context).initPreferences();
          return MaterialApp(
            title: 'Discover',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: "WorkSans",
            ),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
