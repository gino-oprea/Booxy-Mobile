import '../config/booxy-config.dart';
import '../models/working-hours.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkingHoursProvider with ChangeNotifier {
  Future<WorkingHours> getCompanyWorkingHours(int idCompany) async {
    final url = BooxyConfig.api_endpoint +
        'CompanyBack/GetCompanyWorkingHours/' +
        idCompany.toString();
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return null;
    }

    final List<dynamic> objList = extractedData["objList"];

    if (objList.length == 0) return null;

    var value = objList[0];
    var wh = new WorkingHours().fromJson(value);

    return wh;
  }
}
