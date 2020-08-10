import 'dart:convert';

import 'package:booxy/config/booxy-config.dart';
import '../models/log-item.dart';
import '../config/booxy-config.dart';
import 'package:http/http.dart' as http;

class LogProvider {
  Future<void> setLog(LogItem logItem) async {
    String url = BooxyConfig.api_endpoint + 'logs';

    var bdyObj = json.encode(logItem.toJson());

    await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: bdyObj);
  }
}
