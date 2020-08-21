import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';

import '../config/booxy-config.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  Timer _authTimer;
  User currentUser;
  String currentCulture = 'RO';

  Future<bool> login(String email, String password) async {
    String url = BooxyConfig.token_api_endpoint;

    var map = new Map<String, dynamic>();
    map['username'] = email;
    map['password'] = password;
    map['grant_type'] = 'password';
    map['client_id'] = 'angular_client_resOwner';
    map['client_secret'] = 'dcf47e41-8a50-49ff-ab90-aea7137ae991';
    map['scope'] = 'bookingWebApi';

    final response = await http.post(url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: map);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData['error'] != null) return false;

    Token token = new Token().fromJson(extractedData);
    token.token_generated = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    final tokenData = json.encode(token.toJson());
    prefs.setString('tokenData', tokenData);

    User usr = await this.getUserByEmail(email.trim(), token.access_token);
    usr.password = password;
    usr.token = token.access_token;

    final userData = json.encode(usr.toJson());
    prefs.setString('authUser', userData);

    autoLogin();

    this.currentUser = usr;

    return true;
  }

  loginChange() {
    notifyListeners();
  }

  Future<User> getUserByEmail(String email, String authToken) async {
    final url = BooxyConfig.api_endpoint + 'users/getbyemail/' + email;
    final response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + authToken});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    User user = new User().fromJson(extractedData);

    return user;
  }

  Future<String> getCurrentCulture() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('currentCulture')) return 'RO';
    return prefs.getString('currentCulture');
  }

  Future<void> setCurrentCulture(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentCulture', value);
    this.currentCulture = value;
    notifyListeners();
  }

  Future<bool> get isAuth async {
    return await token != null;
  }

  Future<User> get currentUserProp async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('authUser')) return null;

    var usr = new User().fromJson(
        json.decode(prefs.getString('authUser')) as Map<String, Object>);

    this.currentUser = usr;
    if (usr != null) {
      return usr;
    }
    return null;
  }

  Future<Token> get token async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('tokenData')) return null;

    var token = new Token().fromJson(
        json.decode(prefs.getString('tokenData')) as Map<String, Object>);

    if (token != null && token.access_token != null && token.isValid()) {
      return token;
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    prefs.remove('tokenData');
    prefs.remove('authUser');

    this.currentUser = null;
  }

  void autoLogin() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    LoginProvider().token.then((token) {
      if (token != null) {
        var dur = Duration(seconds: 0);
        if (token.isValid()) {
          var expiryDate = token.token_generated.add(
            Duration(
              seconds: token.expires_in,
            ),
          );
          var timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
          dur = Duration(seconds: timeToExpiry);
        }

        currentUserProp.then((usr) {
          if (usr != null) {
            _authTimer = Timer(dur, () {
              login(usr.email, usr.password);
            });
          }
        });
      } else {
        currentUserProp.then((usr) {
          if (usr != null) {
            login(usr.email, usr.password);
          }
        });
      }
    });
  }
}
