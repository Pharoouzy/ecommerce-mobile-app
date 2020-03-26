import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {

  static final String endPoint = '/v1/auth/login';

  // Keys to store and fetch data from SharedPreferences
  static final String accessTokenKey = 'access_token';
  static final String userIdKey = 'user_id';
  static final String emailKey = 'email';
  static final String roleKey = 'role';

  static String getToken(SharedPreferences prefs) {
    return prefs.getString(accessTokenKey);
  }

  static insertDetails(SharedPreferences prefs, var response) {
    prefs.setString(accessTokenKey, response['access_token']);
    var user = response['user'];
    prefs.setInt(userIdKey, user['id']);
    prefs.setString(emailKey, user['email']);
  }

}