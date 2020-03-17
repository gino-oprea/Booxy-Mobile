import 'dart:convert';

import '../config/booxy-config.dart';
import '../models/generic-dictionary-item.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider with ChangeNotifier {
  List<GenericDictionaryItem> _categories = [];
  List<GenericDictionaryItem> _subCategories = [];

  CategoriesProvider(this._categories, this._subCategories);

  List<GenericDictionaryItem> get categories {
    return _categories;
  }

  List<GenericDictionaryItem> get subCategories {
    return _subCategories;
  }

  Future<void> getCategories() async {
    final url = BooxyConfig.api_endpoint + 'CompanyBack/GetActivityCategoriesDic';
    final response = await http.get(url);
    final List<GenericDictionaryItem> loadedCategories = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    final List<dynamic> objList = extractedData["objList"];

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var category = new GenericDictionaryItem().fromJson(value);
      loadedCategories.add(category);
    }
    _categories = loadedCategories;
    notifyListeners();
  }

  Future<void> getSubcategories(int idCategory) async {
    final url = BooxyConfig.api_endpoint + 'CompanyBack/GetActivitySubCategoriesDic/'+idCategory.toString();
    final response = await http.get(url);
    final List<GenericDictionaryItem> loadedSubcategories = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    final List<dynamic> objList = extractedData["objList"];

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var subCategory = new GenericDictionaryItem().fromJson(value);
      loadedSubcategories.add(subCategory);
    }

    _subCategories = loadedSubcategories;
    notifyListeners();
  }
}
