import 'dart:convert';
import '../models/timeslot.dart';
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

  Future<List<List<List<Timeslot>>>> generateHoursMatrix(int idCompany,
      List<String> weekDates, List<LevelAsFilter> selectedLevels) async {
    String url = BooxyConfig.api_endpoint +
        'Booking/GenerateHoursMatrix/' +
        idCompany.toString();

    String httpParams = '';
    weekDates.forEach((date) {
      if (httpParams.isEmpty)
        httpParams = '?weekDates=' + date;
      else
        httpParams += '&weekDates=' + date;
    });

    url += httpParams;

    var bdyObj =json.encode(selectedLevels.map((l)=>l.toJson()).toList());

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: bdyObj);

    final List<List<List<Timeslot>>> timeslots = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    final List<dynamic> objList = extractedData["objList"];
    if (objList.length == 0) return null;
  }
}
