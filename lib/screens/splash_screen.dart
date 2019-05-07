import 'package:discover/screens/home_screen.dart';
import 'package:discover/screens/login_screen.dart';
import 'package:discover/utils/keys/asset_key.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initSplashData();
  }

  Future<void> _initSplashData() async {
    await Future.wait([_initUserPosition()]);
    _changeScreen();
  }

  Future<void> _initUserPosition() async {
    Position position = await Future.any([
      _getTimeoutPosition(),
      Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
    ]);
    PreferencesProvider.of(context).setUserPosition(position);
  }

  Future<Position> _getTimeoutPosition() async {
    await Future.delayed(const Duration(seconds: 5));
    return await Geolocator().getLastKnownPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  void _changeScreen() {
    bool isLogged = PreferencesProvider.of(context).isLogin();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLogged ? HomeScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: SizedBox.shrink()),
          Expanded(
            child: Center(
              child: SvgPicture.asset(AssetKey.logoSvg, width: 180),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 42.0),
                Text('Getting your position...')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
