import 'dart:convert';

import '../models/generic-response-object.dart';
import '../models/log-item.dart';
import '../config/booxy-config.dart';
import 'package:http/http.dart' as http;

class LogProvider {
  Future<GenericResponseObject> setLog(LogItem logItem) async {
    String url = BooxyConfig.api_endpoint + 'logs';

    var bdyObj = json.encode(logItem.toJson());

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: bdyObj);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    return gro;
  }
}
