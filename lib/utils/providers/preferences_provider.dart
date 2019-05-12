import 'package:discover/models/posts/sort_mode.dart';
import 'package:discover/models/users/user.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/utils/keys/pref_key.dart';
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
  Position _userPosition;
  User _user;
  SortMode _sortMode;

  bool isLogin() => _user != null && _user.isValid;

  Position getUserPos() {
    return _userPosition ?? Position(latitude: 48.789311, longitude: 2.363550);
  }

  void setUserPosition(Position userPosition, [bool state = false]) {
    _setPref(() => _userPosition = userPosition, state);
    widget.prefs.setString(
      PrefKey.lastUserPos,
      positionToJsonString(userPosition),
    );
  }

  User getUser() => _user;

  void setUser(User user, [bool state = false]) {
    _setPref(() => _user = user, state);
    widget.prefs.setString(PrefKey.user, user.toRawJson());
  }

  SortMode getSortMode() => _sortMode;

  void setSortMode(SortMode sortMode, [bool state = false]) {
    _setPref(() => _sortMode = sortMode, state);
    widget.prefs.setString(PrefKey.sortMode, sortMode?.value);
  }

  void initPreferences() {
    if (_isPrefInit) return;
    _userPosition = stringToPosition(
      widget.prefs.getString(PrefKey.lastUserPos),
    );
    String userJson = widget.prefs.getString(PrefKey.user);
    if (userJson != null) {
      _user = User.fromRawJson(userJson);
    }
    _sortMode = SortMode.fromValue(widget.prefs.getString(PrefKey.sortMode));
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
