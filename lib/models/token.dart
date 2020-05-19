import 'package:intl/intl.dart';

class Token {
  String access_token;
  int expires_in;
  String scope;
  String token_type;
  DateTime token_generated;

  Token(
      {this.access_token,
      this.expires_in,
      this.scope,
      this.token_type,
      this.token_generated});

  Token fromJson(Map json) {
    this.access_token = json['access_token'];
    this.expires_in = json['expires_in'];
    this.scope = json['scope'];
    this.token_type = json['token_type'];
    this.token_generated =
        json['token_generated'] != null && json['token_generated'] != "" ? DateTime.parse(json['token_generated']) : null;

    return this;
  }

  Map toJson() {
    Map obj = {
      'access_token': this.access_token,
      'expires_in': this.expires_in,
      'scope': this.scope,
      'token_type': this.token_type,
      'token_generated':
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(this.token_generated)
    };

    return obj;
  }

  bool isValid() {
    bool valid = true;

    var expiryDate = this.token_generated.add(
          Duration(
            seconds: expires_in,
          ),
        );

    if (expiryDate.isBefore(DateTime.now())) valid = false;

    return valid;
  }
}
