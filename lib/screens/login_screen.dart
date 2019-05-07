import 'package:discover/models/users/request/login_payload.dart';
import 'package:discover/models/users/request/register_payload.dart';
import 'package:discover/models/users/user.dart';
import 'package:discover/screens/home_screen.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/ui/tab_indicator_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';


enum Field { FIRSTNAME, LASTNAME, EMAIL, PASSWORD, PWDCONFIRM }

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formSignInKey = GlobalKey<FormState>();
  final _formSignUpKey = GlobalKey<FormState>();

  // Login
  final _focusPwdLogin = FocusNode();
  final _signInValues = <Field, String>{
    Field.EMAIL: "",
    Field.PASSWORD: "",
  };

  // SignUp
  final _focusLastnameSignup = FocusNode();
  final _focusEmailSignup = FocusNode();
  final _focusPwdSignup = FocusNode();
  final _focusPwdConfirmSignup = FocusNode();
  final _signUpValues = <Field, String>{
    Field.FIRSTNAME: "",
    Field.LASTNAME: "",
    Field.EMAIL: "",
    Field.PASSWORD: "",
    Field.PWDCONFIRM: "",
  };

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _focusPwdLogin.dispose();
    _focusLastnameSignup.dispose();
    _focusEmailSignup.dispose();
    _focusPwdSignup.dispose();
    _focusPwdConfirmSignup.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(gradient: Gradients.coldLinear),
            child: Column(
              children: [
                const SizedBox(height: 75),
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 200,
                ),
                const SizedBox(height: 32),
                _buildMenuBar(context),
                const SizedBox(height: 22),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      setState(() {
                        right = i == 0 ? Colors.white : Colors.black;
                        left = i == 0 ? Colors.black : Colors.white;
                      });
                    },
                    children: [
                      _buildSignIn(context),
                      _buildSignUp(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, Function callback, Color colorText) {
    return Expanded(
      child: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: callback,
        child: Text(
          text,
          style: TextStyle(
            color: colorText,
            fontSize: 16.0,
            fontFamily: "WorkSans",
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.3,
      decoration: BoxDecoration(
        color: const Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          children: [
            _buildMenuButton("Login", () => _changePage(0), left),
            _buildMenuButton("Register", () => _changePage(1), right),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    @required IconData icon,
    @required String hint,
    TextInputType inputType = TextInputType.text,
    FocusNode focusNode,
    FocusNode nextFocus,
    FormFieldSetter<String> onSaved,
    bool isPassword = false,
  }) {
    return TextFormField(
      focusNode: focusNode,
      keyboardType: inputType,
      onSaved: onSaved,
      obscureText: isPassword,
      style: const TextStyle(
        fontFamily: "WorkSans",
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Icon(icon),
        ),
        contentPadding: const EdgeInsets.only(top: 20, bottom: 20, right: 25),
        hintStyle: const TextStyle(fontFamily: "WorkSans", fontSize: 17.0),
      ),
      textInputAction: nextFocus != null ? TextInputAction.next : null,
      onFieldSubmitted: (value) {
        if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
      },
    );
  }

  Widget _buildBtn(String text, VoidCallback onPressed) {
    return GradientButton(
      increaseHeightBy: 12,
      increaseWidthBy: 80,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: "WorkSansBold",
        ),
      ),
      callback: onPressed,
      gradient: Gradients.hotLinear,
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: [
        Card(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: 300.0,
            height: 150.0,
            child: Form(
              key: _formSignInKey,
              child: Column(
                children: [
                  _buildTextField(
                    icon: Icons.email,
                    hint: "Email Address",
                    inputType: TextInputType.emailAddress,
                    nextFocus: _focusPwdLogin,
                    onSaved: (value) => _signInValues[Field.EMAIL] = value,
                  ),
                  const Divider(height: 0),
                  _buildTextField(
                    icon: Icons.lock,
                    hint: "Password",
                    focusNode: _focusPwdLogin,
                    onSaved: (value) => _signInValues[Field.PASSWORD] = value,
                    isPassword: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(top: 130.0, child: _buildBtn('Login', _onSignIn)),
      ],
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: [
        Card(
          elevation: 5.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: 300.0,
            height: 332.0,
            child: Form(
              key: _formSignUpKey,
              child: Column(
                children: [
                  _buildTextField(
                    icon: Icons.person,
                    hint: "First name",
                    nextFocus: _focusLastnameSignup,
                    onSaved: (value) => _signUpValues[Field.FIRSTNAME] = value,
                  ),
                  const Divider(height: 0),
                  _buildTextField(
                    icon: Icons.person,
                    hint: "Last name",
                    nextFocus: _focusEmailSignup,
                    onSaved: (value) => _signUpValues[Field.LASTNAME] = value,
                  ),
                  const Divider(height: 0),
                  _buildTextField(
                    icon: Icons.email,
                    hint: "Email Address",
                    inputType: TextInputType.emailAddress,
                    focusNode: _focusEmailSignup,
                    nextFocus: _focusPwdSignup,
                    onSaved: (value) => _signUpValues[Field.EMAIL] = value,
                  ),
                  const Divider(height: 0),
                  _buildTextField(
                    icon: Icons.lock,
                    hint: "Password",
                    focusNode: _focusPwdSignup,
                    nextFocus: _focusPwdConfirmSignup,
                    onSaved: (value) => _signUpValues[Field.PASSWORD] = value,
                    isPassword: true,
                  ),
                  const Divider(height: 0),
                  _buildTextField(
                    icon: Icons.lock,
                    hint: "Confirmation",
                    focusNode: _focusPwdConfirmSignup,
                    onSaved: (value) => _signUpValues[Field.PWDCONFIRM] = value,
                    isPassword: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(top: 310.0, child: _buildBtn('Signup', _onSignUp)),
      ],
    );
  }

  void _changePage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void _onSignIn() async {
    _formSignInKey.currentState?.save();

    final email = _signInValues[Field.EMAIL].trim();
    final pwd = _signInValues[Field.PASSWORD];

    if (email.isEmpty || pwd.isEmpty) {
      return _showMessage("You must fill all textfields");
    } else if (!isEmail(email)) {
      return _showMessage("Email is wrong");
    }

    try {
      User response = await Api().login(
        LoginPayload(email: email, password: pwd),
      );
      PreferencesProvider.of(context).setUser(response);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  void _onSignUp() async {
    _formSignUpKey.currentState?.save();

    final email = _signUpValues[Field.EMAIL].trim();
    final pwd = _signUpValues[Field.PASSWORD];
    final pwdConfirm = _signUpValues[Field.PWDCONFIRM];
    final firstName = _signUpValues[Field.FIRSTNAME].trim();
    final lastName = _signUpValues[Field.LASTNAME].trim();

    if (email.isEmpty ||
        pwd.isEmpty ||
        pwdConfirm.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      return _showMessage("You must fill all textfields");
    } else if (!isEmail(email)) {
      return _showMessage("Email is wrong");
    } else if (pwd != pwdConfirm) {
      return _showMessage("Password and confirmation are not identical");
    }

    try {
      User response = await Api().register(RegisterPayload(
        email: email,
        password: pwd,
        firstName: firstName,
        lastName: lastName,
      ));
      PreferencesProvider.of(context).setUser(response);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
