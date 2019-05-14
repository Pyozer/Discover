import 'package:discover/models/posts/sort_mode.dart';
import 'package:discover/models/tags/tag.dart';
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
  bool _isCustomPos;
  User _user;
  SortMode _sortMode;
  double _filterDistance;
  List<Tag> _filterTags;

  bool isLogin() => _user != null && _user.isValid;

  Position getUserPos() => _userPosition;

  void setUserPosition(Position userPosition, [bool state = false]) {
    _setPref(() => _userPosition = userPosition, state);
    widget.prefs.setString(
      PrefKey.lastUserPos,
      positionToJsonString(userPosition),
    );
  }

  bool isCustomPos() => _isCustomPos ?? false;

  void setCustomPos(bool isCustomPos, [bool state = false]) {
    _setPref(() => _isCustomPos = isCustomPos, state);
    widget.prefs.setBool(PrefKey.isCustomPos, isCustomPos);
  }

  User getUser() => _user;

  void setUser(User user, [bool state = false]) {
    _setPref(() => _user = user, state);
    widget.prefs.setString(PrefKey.user, user?.toRawJson());
  }

  SortMode getSortMode() => _sortMode;

  void setSortMode(SortMode sortMode, [bool state = false]) {
    _setPref(() => _sortMode = sortMode, state);
    widget.prefs.setString(PrefKey.sortMode, sortMode?.value);
  }

  double getFilterDistance() => _filterDistance ?? 300.0;

  void setFilterDistance(double distance, [bool state = false]) {
    _setPref(() => _filterDistance = distance, state);
    widget.prefs.setDouble(PrefKey.filterDistance, distance);
  }

  List<Tag> getFilterTags() => _filterTags ?? [];

  void setFilterTags(List<Tag> tags, [bool state = false]) {
    _setPref(() => _filterTags = tags, state);
    widget.prefs.setStringList(
      PrefKey.filterTags,
      tags.map((t) => t.toRawJson()).toList(),
    );
  }

  void initPreferences() {
    if (_isPrefInit) return;
    _userPosition = stringToPosition(
      widget.prefs.getString(PrefKey.lastUserPos),
    );
    _isCustomPos = widget.prefs.getBool(PrefKey.isCustomPos);
    String userJson = widget.prefs.getString(PrefKey.user);
    if (userJson != null) {
      _user = User.fromRawJson(userJson);
    }
    _sortMode = SortMode.fromValue(widget.prefs.getString(PrefKey.sortMode));
    _filterDistance = widget.prefs.getDouble(PrefKey.filterDistance);
    _filterTags = widget.prefs
            .getStringList(PrefKey.filterTags)
            ?.map((s) => Tag.fromRawJson(s))
            ?.toList() ??
        [];
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
