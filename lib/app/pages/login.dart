import 'dart:async';
import 'package:olakineasy/app/pages/home.dart';
import 'package:olakineasy/app/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olakineasy/app/utils/network.dart';
import 'package:olakineasy/app/validators/email.dart';
import 'package:olakineasy/app/components/error_box.dart';
import 'package:olakineasy/app/components/email_field.dart';
import 'package:olakineasy/app/components/password_field.dart';
import 'package:olakineasy/app/components/login_button.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  bool _isError = false;
  bool _obscureText = true;
  bool _isLoading = false;
  TextEditingController _emailController, _passwordController;
  String _errorText, _emailError, _passwordError;

  @override
  void initState(){
    super.initState();
    _fetchSessionAndNavigate();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _preferences;
    String access_token = AuthUtils.getToken(_sharedPreferences);

    if(access_token != null){
      Navigator.of(_scaffoldKey.currentContext)
        .pushReplacementNamed(HomePage.routeName);
    }

  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _authenticateUser() async {
    _showLoading();
    if(_valid()){
      var jsonResponse = await NetworkUtils.authenticateUser(
        _emailController.text, _passwordController.text
      );
      
      print(jsonResponse);

      if(jsonResponse == null){
        NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
      }
      else if(jsonResponse == 'NetworkError'){
        NetworkUtils.showSnackBar(_scaffoldKey, null);
      }
      else if(jsonResponse['message'] != null) {
        NetworkUtils.showSnackBar(_scaffoldKey, jsonResponse['message']);
      }
      else {
        AuthUtils.insertDetails(_sharedPreferences, jsonResponse);
        Navigator.of(_scaffoldKey.currentContext)
            .pushReplacementNamed(HomePage.routeName);
      }
      _hideLoading();
    }
    else{
      setState(() {
        _isLoading = false;
        _emailError;
        _passwordError;
      });
    }
  }

  _valid() {
    bool valid = true;

    if(_emailController.text.isEmpty) {
      valid = false;
      _emailError = "Email can't be blank!";
    }
    else if(!_emailController.text.contains(EmailValidator.regex)){
      valid = false;
      _emailError = "Enter valid email!";
    }

    if(_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = "Password can't be blank!";
    }
    else if(_passwordController.text.length < 6) {
      valid = false;
      _passwordError = "Password is invalid!";
    }

    return valid;
  }

  Widget _loginScreen() {
    return new Container(
      child: new ListView(
        padding: const EdgeInsets.only(
          top: 100.0,
          left: 16.0,
          right: 160
        ),
        children: <Widget>[
          new ErrorBox(
              isError: _isError,
              errorText: _errorText
          ),
          new EmailField(
              emailController: _emailController,
              emailError: _emailError
          ),
          new PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
          ),
          new LoginButton(onPressed: _authenticateUser)
        ],
      ),
    );
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _loadingScreen() {
    return new Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: new Center(
            child: new Column(
              children: <Widget>[
                new CircularProgressIndicator(
                    strokeWidth: 4.0
                ),
                new Container(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    'Please Wait',
                    style: new TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16.0
                    ),
                  ),
                )
              ],
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: _isLoading ? _loadingScreen() : _loginScreen()
    );
  }
}
