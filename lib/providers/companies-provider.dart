import 'dart:io';

import '../config/booxy-config.dart';
import '../models/generic-response-object.dart';

import '../models/company.dart';
import '../models/booxy-image.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login-provider.dart';

class CompaniesProvider with ChangeNotifier {
  List<Company> _companies = [];
  List<int> favouritesIds = [];

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

  Future<void> getFavouriteCompaniesIds() async {
    final url = BooxyConfig.api_endpoint + 'CompanyBack/GetFavouriteCompanies';
    var token = await LoginProvider().token;

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.access_token
    });

    final List<int> favCompIds = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return;
    }

    final List<dynamic> objList = extractedData["objList"];

    for (int i = 0; i < objList.length; i++) {
      var idComp = objList[i];

      favCompIds.add(idComp);
    }

    favouritesIds = favCompIds;
    notifyListeners();
  }

  Future<GenericResponseObject> setFavouriteCompany(int idCompany) async {
    final url = BooxyConfig.api_endpoint +
        'CompanyBack/SetFavouriteCompany/' +
        idCompany.toString();
    var token = await LoginProvider().token;

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token.access_token
        },
        body: null);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    if (gro.error == '') this.favouritesIds.add(idCompany);

    return gro;
  }

  Future<GenericResponseObject> deleteFavouriteCompany(int idCompany) async {
    final url = BooxyConfig.api_endpoint +
        'CompanyBack/DeleteFavouriteCompany/' +
        idCompany.toString();
    var token = await LoginProvider().token;

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer " + token.access_token
    });

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    if (gro.error == '') this.favouritesIds.remove(idCompany);

    return gro;
  }

  bool isFavourite(int idCompany) {
    bool exists = false;
    this
                .favouritesIds
                .firstWhere((fId) => fId == idCompany, orElse: () => null) !=
            null
        ? exists = true
        : exists = false;

    return exists;
  }

  Future<GenericResponseObject> getMyCompanies(int idUser) async {
    final url = BooxyConfig.api_endpoint + 'CompanyBack/' + idUser.toString();
    var token = await LoginProvider().token;
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.access_token
    });
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    gro.objList = new List<Company>();
    if (gro.objListAsMap != null)
      for (int i = 0; i < gro.objListAsMap.length; i++) {
        var obj = new Company().fromJson(gro.objListAsMap[i]);
        obj.image = await getCompanyImages(obj.id);
        gro.objList.add(obj);
      }

    return gro;
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
