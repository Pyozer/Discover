import 'package:discover/utils/functions.dart';
import 'package:discover/utils/keys/prefkey.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _PreferencesInherited extends InheritedWidget {
  final Widget child;
  final PreferencesProviderState state;

  _PreferencesInherited({Key key, @required this.child, @required this.state})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_PreferencesInherited oldWidget) => true;
}

class PreferencesProvider extends StatefulWidget {
  final Widget child;
  final SharedPreferences prefs;

  PreferencesProvider({Key key, @required this.child, @required this.prefs})
      : super(key: key);

  PreferencesProviderState createState() => PreferencesProviderState();

  static PreferencesProviderState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_PreferencesInherited)
            as _PreferencesInherited)
        .state;
  }
}

class PreferencesProviderState extends State<PreferencesProvider> {
  bool _isPrefInit = false;
  bool _isLogin = false;
  Position _userPosition;
  String _authToken;

  bool isLogin() => _isLogin ?? false;

  void setLogin(bool isUserLogged, [bool state = false]) {
    _setPref(() => _isLogin = isUserLogged, state);
    widget.prefs.setBool(PrefKey.isLogged, isUserLogged);
  }

  Position getUserPos() => _userPosition;

  void setUserPosition(Position userPosition, [bool state = false]) {
    _setPref(() => _userPosition = userPosition, state);
    widget.prefs.setString(
      PrefKey.lastUserPos,
      positionToJsonString(userPosition),
    );
  }

  String authToken() => _authToken;

  void setAuthToken(String authToken, [bool state = false]) {
    _setPref(() => _authToken = authToken, state);
    widget.prefs.setString(PrefKey.authToken, authToken);
  }

  void initPreferences() {
    if (_isPrefInit) return;
    _isLogin = widget.prefs.getBool(PrefKey.isLogged);
    /*_userPosition = stringToPosition(
      widget.prefs.getString(PrefKey.lastUserPos),
    );*/
    _authToken = widget.prefs.getString(PrefKey.authToken);
    _isPrefInit = true;
  }

  void _setPref(Function function, [bool state = false]) {
    if (state)
      setState(function);
    else
      function();
  }

  @override
  Widget build(BuildContext context) {
    return _PreferencesInherited(child: widget.child, state: this);
  }
}