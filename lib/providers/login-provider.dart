import 'dart:convert';
import 'dart:io';

import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';

import '../config/booxy-config.dart';
import 'package:http/http.dart' as http;

class LoginProvider {
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

    final prefs = await SharedPreferences.getInstance();
    final tokenData = json.encode(token.toJson());
    prefs.setString('tokenData', tokenData);

    User currentUser =
        await this.getUserByEmail(email.trim(), token.access_token);
    currentUser.password = password;
    currentUser.token = token.access_token;

    final userData = json.encode(currentUser.toJson());
    prefs.setString('authUser', userData);

    return true;
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

  Future<bool> get isAuth async {
    return await token != null;
  }

  Future<User> get currentUser async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('authUser')) return null;

    var currentUser = new User().fromJson(
        json.decode(prefs.getString('authUser')) as Map<String, Object>);

    if (currentUser != null) {
      return currentUser;
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
    prefs.remove('tokenData');
    prefs.remove('authUser');
  }
}
