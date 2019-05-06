import 'package:flutter/material.dart';

class _LoginInherited extends InheritedWidget {
  final Widget child;
  final LoginProviderState state;

  _LoginInherited({Key key, @required this.child, @required this.state})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_LoginInherited oldWidget) => true;
}

class LoginProvider extends StatefulWidget {
  final Widget child;

  LoginProvider({Key key, @required this.child}) : super(key: key);

  LoginProviderState createState() => LoginProviderState();

  static LoginProviderState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_LoginInherited)
            as _LoginInherited)
        .state;
  }
}

class LoginProviderState extends State<LoginProvider> {
  bool _isLogin = false;

  bool isLogin() => _isLogin ?? false;

  void setLogin(bool isUserLogged) {
    setState(() => _isLogin = isUserLogged);
  }

  @override
  Widget build(BuildContext context) {
    return _LoginInherited(child: widget.child, state: this);
  }
}
