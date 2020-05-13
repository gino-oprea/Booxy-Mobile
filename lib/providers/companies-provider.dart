import 'package:booxy/config/booxy-config.dart';

import '../models/company.dart';
import '../models/booxy-image.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompaniesProvider with ChangeNotifier {
  List<Company> _companies = [];

  CompaniesProvider(this._companies);

  List<Company> get companies {
    return _companies;
  }

  Future<void> getCompanies(
      [String companyName = '',
      int idCategory,
      int idSubcategory,
      int idCounty,
      int idCity]) async {
    final url = BooxyConfig.api_endpoint +
        'CompanyFront?id=null&name=$companyName&idCategory=$idCategory&idSubcategory=$idSubcategory&idCountry=null&idCounty=$idCounty&idCity=$idCity';
    final response = await http.get(url);
    final List<Company> loadedCompanies = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return;
    }

    final List<dynamic> objList = extractedData["objList"];

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var comp = new Company().fromJson(value);

      comp.image = await getCompanyImages(comp.id);
      loadedCompanies.add(comp);
    }
    
    _companies = loadedCompanies;
    notifyListeners();
  }

  Future<List<BooxyImage>> getCompanyImages(int idCompany) async {
    final url = BooxyConfig.api_endpoint +
        'Image/GetCompanyImages/' +
        idCompany.toString();
    final response = await http.get(url);
    final List<BooxyImage> loadedImages = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    final objList = extractedData["objList"];
    objList.forEach((value) {
      loadedImages.add(new BooxyImage().fromJson(value));
    });

    return loadedImages;
  }
}
