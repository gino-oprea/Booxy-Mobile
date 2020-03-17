import 'dart:convert';

import '../config/booxy-config.dart';
import '../models/county.dart';
import '../models/city.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CompanyLocationProvider with ChangeNotifier {
  List<County> _counties = [];
  List<City> _cities = [];

  CompanyLocationProvider(this._counties, this._cities);

  List<County> get counties {
    return _counties;
  }

  List<City> get cities {
    return _cities;
  }

  Future<void> getCounties() async {
    final url = BooxyConfig.api_endpoint + 'CompanyLocation/GetCounties/1';
    final response = await http.get(url);
    final List<County> loadedCounties = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    final List<dynamic> objList = extractedData["objList"];

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var county = new County().fromJson(value);
      loadedCounties.add(county);
    }

    _counties = loadedCounties;
    notifyListeners();
  }

  Future<void> getCities(int idCounty) async {
    final url = BooxyConfig.api_endpoint + 'CompanyLocation/GetCities/'+idCounty.toString();
    final response = await http.get(url);
    final List<City> loadedCities = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    final List<dynamic> objList = extractedData["objList"];

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var city = new City().fromJson(value);
      loadedCities.add(city);
    }

    _cities = loadedCities;
    notifyListeners();
  }
}
