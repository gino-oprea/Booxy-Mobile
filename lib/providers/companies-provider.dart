import 'package:booxy/config/booxy-config.dart';

import '../models/company.dart';
import '../models/image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompaniesProvider with ChangeNotifier {
  List<Company> _companies = [];

  CompaniesProvider(this._companies);

  List<Company> get companies {
    return _companies;
  }

  Future<void> getCompanies() async {
    final url = BooxyConfig.api_endpoint +
        'CompanyFront?id=null&name=&idCategory=null&idSubcategory=null&idCountry=null&idCounty=null&idCity=null';
    final response = await http.get(url);
    final List<Company> loadedCompanies = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return;
    }

    final objList = extractedData["objList"];
    objList.forEach((value) {
      var comp = new Company().fromJson(value);

      getCompanyImages(comp).then((_) {
        loadedCompanies.add(comp);

        _companies = loadedCompanies;
        notifyListeners();
      });
    });
  }

  Future<void> getCompanyImages(Company comp) async {
    final url = BooxyConfig.api_endpoint +
        'Image/GetCompanyImages/' +
        comp.id.toString();
    final response = await http.get(url);
    final List<BooxyImage> loadedImages = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }

    final objList = extractedData["objList"];
    objList.forEach((value) {
      loadedImages.add(new BooxyImage().fromJson(value));
    });

    comp.image = loadedImages;
  }
}
