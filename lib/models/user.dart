import 'package:intl/intl.dart';

import './user-role.dart';

class User {
  int id;
  String email;
  List<UserRole> roles;
  String firstName;
  String lastName;
  String phone;
  String password;
  DateTime creationDate;
  String activationKey;
  bool isEnabled;
  DateTime lastLoginDate;
  String token;
  String error;
  String errorDetailed;

  User(
      {this.id,
      this.email,
      this.roles,
      this.firstName,
      this.lastName,
      this.phone,
      this.password,
      this.creationDate,
      this.activationKey,
      this.isEnabled,
      this.lastLoginDate,
      this.token,
      this.error,
      this.errorDetailed});

  User fromJson(Map json) {
    this.id = json['id'];
    this.email = json['email'];

    this.roles = new List<UserRole>();
    List<dynamic> rawRoles = json['roles'];
    for (int i = 0; i < rawRoles.length; i++) {
      var roleMap = rawRoles[i];
      var role = new UserRole().fromJson(roleMap);

      this.roles.add(role);
    }

    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.phone = json['phone'];
    this.creationDate = json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate']);
    this.activationKey = json['activationKey'];
    this.isEnabled = json['isEnabled'];
    this.lastLoginDate = json['lastLoginDate'] == null
        ? null
        : DateTime.parse(json['lastLoginDate']);
    this.error = json['error'];
    this.errorDetailed = json['errorDetailed'];

    return this;
  }

  Map toJson() {
    Map obj = {
      'id': this.id,
      'email': this.email,
      'roles': this.roles != null
          ? this.roles.map((r) => r.toJson()).toList()
          : null,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phone': this.phone,
      'password': this.password,
      'creationDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(this.creationDate),
      'activationKey': this.activationKey,
      'isEnabled': this.isEnabled,
      'lastLoginDate':
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(this.lastLoginDate),
      'token': this.token,
      'error': this.error,
      'errorDetailed': this.errorDetailed
    };

    return obj;
  }
}
