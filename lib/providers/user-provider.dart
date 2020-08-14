import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import './login-provider.dart';
import '../models/user.dart';
import '../config/booxy-config.dart';
import 'package:http/http.dart' as http;
import '../models/generic-response-object.dart';

class UserProvider {
  Future<GenericResponseObject> editUser(User user) async {
    String url = BooxyConfig.api_endpoint + 'users/EditUserForFrontOffice';

    var bdyObj = json.encode(user.toJson());

    var authToken = await LoginProvider().token;
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + authToken.access_token
        },
        body: bdyObj);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    if (gro.info.indexOf('success') > -1) {
      //add the changes to shared preffs
      var currentUser = await LoginProvider().currentUser;
      currentUser.firstName = user.firstName;
      currentUser.lastName = user.lastName;
      currentUser.phone = user.phone;
      currentUser.email = user.email;

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(currentUser.toJson());
      prefs.setString('authUser', userData);
    }

    return gro;
  }

  Future<GenericResponseObject> registerUser(User user) async {
    String url = BooxyConfig.api_endpoint + 'users';

    var bdyObj = json.encode(user.toJson());
    
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json'          
        },
        body: bdyObj);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);    

    return gro;
  }
}
