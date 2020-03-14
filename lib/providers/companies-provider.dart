import '../models/company.dart';
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
    final url =
        'http://api.booxy.ro/api/CompanyFront?id=null&name=&idCategory=null&idSubcategory=null&idCountry=null&idCounty=null&idCity=null';
    final response = await http.get(url);
    final List<Company> loadedCompanies = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return;
    }

    final objList = extractedData["objList"];
    objList.forEach((value) {
      loadedCompanies.add(Company(
          id: value['id'],
          name: value['name'],
          description_RO: value['description_RO'],
          description_EN: value['description_EN'],
          idCategory: value['idCategory'],
          categoryName_RO: value['categoryName_RO'],
          categoryName_EN: value['categoryName_EN'],
          idSubcategory: value['idSubcategory'],
          subcategoryName_RO: value['subcategoryName_RO'],
          subcategoryName_EN: value['subcategoryName_EN'],
          email: value['email'],
          phone: value['phone'],
          idCountry: value['idCountry'],
          countryName: value['countryName'],
          idCounty: value['idCounty'],
          idCity: value['idCity'],
          cityName: value['cityName'],
          countyName: value['countyName'],
          address: value['address'],
          lat: value['lat'],
          lng: value['lng'],
          image: null,
          dateCreated: null,
          isEnabled: value['isEnabled'],
          allowOnlineBookings: value['allowOnlineBookings']));
    });

    _companies = loadedCompanies;

    notifyListeners();
  }
}
