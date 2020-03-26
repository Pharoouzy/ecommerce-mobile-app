import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth.dart';

class NetworkUtils {
  static final String host = developmentHost;//productionHost;
  static final String productionHost = 'http://api.olakineasy.com/';
  static final String developmentHost = 'http://api.olakineasy.com/';

  static dynamic authenticateUser(String email, String password) async {
    var uri = host + AuthUtils.endPoint;

    try {
      final response = await http.post(
          uri,
          body: {
            'email': email,
            'password': password,
            'remember_me': true
          }
      );

      final json_response = json.decode(response.body);
      return json_response;

    } catch (exception) {
      print(exception);
      if(exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static logoutUser(BuildContext context, SharedPreferences prefs) {
    prefs.setString(AuthUtils.accessTokenKey, null);
    prefs.setInt(AuthUtils.userIdKey, null);
    prefs.setString(AuthUtils.emailKey, null);
    Navigator.of(context).pushReplacementNamed('/');
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(message ?? 'You are offline'),
        )
    );
  }

  static fetch(var authToken, var endPoint) async {
    var uri = host + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': authToken
        },
      );

      final json_response = json.decode(response.body);
      return json_response;

    } catch (exception) {
      print(exception);
      if(exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
}