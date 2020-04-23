import 'dart:convert';

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

    return true;
  }

  Future<bool> get isAuth async {
    return await token != null;
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

  Future<void> logout()  async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenData');
  }
}
