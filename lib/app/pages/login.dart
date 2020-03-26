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
  bool isError =

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
