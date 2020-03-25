import 'dart:convert';

import '../models/level-as-filter.dart';

import '../config/booxy-config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingProvider with ChangeNotifier {
  Future<List<LevelAsFilter>> getLevelsAsFilters(
      int idCompany, List<String> weekDates) async {
    String url = BooxyConfig.api_endpoint +
        'Booking/GetBookingFilters/' +
        idCompany.toString();

    String httpParams = '';
    weekDates.forEach((date) {
      if (httpParams.isEmpty)
        httpParams = '?weekDates=' + date;
      else
        httpParams += '&weekDates=' + date;
    });

    url += httpParams;

    final response = await http.get(url);
    final List<LevelAsFilter> lvlsAsFilters = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return null;
    }

    final List<dynamic> objList = extractedData["objList"];

    if (objList.length == 0) return null;

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var lvl = new LevelAsFilter().fromJson(value);

      lvlsAsFilters.add(lvl);
    }

    return lvlsAsFilters;
  }
}
