import 'dart:convert';

import '../config/booxy-config.dart';
import 'package:http/http.dart' as http;

class LoginProvider {
  Future<void> login(String email, String password) async {
    String url = BooxyConfig.token_api_endpoint;

    // var bdyObj = json.encode({
    //   'username': email,
    //   'password': password,
    //   'grant_type': 'password',
    //   'client_id': 'angular_client_resOwner',
    //   'client_secret': 'dcf47e41-8a50-49ff-ab90-aea7137ae991',
    //   'scope': 'bookingWebApi'
    // });

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

        final dynamic timeslots = [];
  }
}
