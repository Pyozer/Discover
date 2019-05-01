import 'package:discover/widgets/ui/tab_indicator_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

enum Field { NAME, EMAIL, PASSWORD, PWDCONFIRM }

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
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
  final _focusEmailSignup = FocusNode();
  final _focusPwdSignup = FocusNode();
  final _focusPwdConfirmSignup = FocusNode();
  final _signUpValues = <Field, String>{
    Field.NAME: "",
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
            decoration: BoxDecoration(gradient: Gradients.rainbowBlue),
            child: Column(
              children: [
                const SizedBox(height: 75),
                Image.asset('assets/images/login_logo.png', width: 250),
                const SizedBox(height: 20),
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
  }) {
    return TextFormField(
      focusNode: focusNode,
      keyboardType: inputType,
      onSaved: onSaved,
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
      gradient: Gradients.jShine,
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
            height: 270.0,
            child: Form(
              key: _formSignUpKey,
              child: Column(
                children: [
                  _buildTextField(
                    icon: Icons.person,
                    hint: "Name",
                    nextFocus: _focusEmailSignup,
                    onSaved: (value) => _signUpValues[Field.NAME] = value,
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
                  ),
                  const Divider(height: 0),
                  _buildTextField(
                    icon: Icons.lock,
                    hint: "Confirmation",
                    focusNode: _focusPwdConfirmSignup,
                    onSaved: (value) => _signUpValues[Field.PWDCONFIRM] = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(top: 250.0, child: _buildBtn('Signup', _onSignUp)),
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

  void _onSignIn() {
    _formSignInKey.currentState?.save();
    //TODO: Add fields check
  }

  void _onSignUp() {
    _formSignUpKey.currentState?.save();
    //TODO: Add fields check
  }
}
