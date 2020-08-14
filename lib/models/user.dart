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
    this.password = json["password"] != null ? json["password"] : null;

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
    Map obj = Map();

    if (this.id != null) obj['id'] = this.id;
    if (this.email != null) obj['email'] = this.email;
    if (this.roles != null)
      obj['roles'] = this.roles.map((r) => r.toJson()).toList();
    if (this.firstName != null) obj['firstName'] = this.firstName;
    if (this.lastName != null) obj['lastName'] = this.lastName;
    if (this.phone != null) obj['phone'] = this.phone;
    if (this.password != null) obj['password'] = this.password;
    if (this.creationDate != null)
      obj['creationDate'] =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(this.creationDate);
    if (this.activationKey != null) obj['activationKey'] = this.activationKey;
    if (this.isEnabled != null) obj['isEnabled'] = this.isEnabled;
    if (this.lastLoginDate != null)
      obj['lastLoginDate'] =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(this.lastLoginDate);
    if (this.token != null) obj['token'] = this.token;
    if (this.error != null) obj['error'] = this.error;
    if (this.errorDetailed != null) obj['errorDetailed'] = this.errorDetailed;

    return obj;
  }
}
