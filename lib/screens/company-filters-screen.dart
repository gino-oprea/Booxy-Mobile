import '../models/company-filter.dart';

import '../models/city.dart';
import '../models/generic-dictionary-item.dart';
import '../models/county.dart';
import 'package:flutter/material.dart';

class CompanyFiltersScreen extends StatefulWidget {
  static String routeName = '/company-filters';

  @override
  _CompanyFiltersScreenState createState() => _CompanyFiltersScreenState();
}

class _CompanyFiltersScreenState extends State<CompanyFiltersScreen> {
  County _selectedCounty;
  City _selectedCity;
  GenericDictionaryItem _selectedCategory;
  GenericDictionaryItem _selectedSubCategory;

  List<County> _counties = [
    County(id: 1, code: 'B', idCountry: 1, name: 'Bucuresti'),
    County(id: 2, code: 'AG', idCountry: 1, name: 'Arges'),
    County(id: 3, code: 'BR', idCountry: 1, name: 'Brasov'),
    County(id: 4, code: 'CT', idCountry: 1, name: 'Constanta'),
  ];

  List<City> _cities = [
    City(id: 1, name: 'Bucuresti'),
    City(id: 2, name: 'Pitesti'),
    City(id: 3, name: 'Arad'),
    City(id: 4, name: 'Giurgiu'),
  ];

  List<GenericDictionaryItem> _categories = [
    GenericDictionaryItem(id: 1, value_RO: 'Altele'),
    GenericDictionaryItem(id: 2, value_RO: 'Frumusete'),
    GenericDictionaryItem(id: 3, value_RO: 'Sanatate'),
  ];

  List<GenericDictionaryItem> _subCategories = [
    GenericDictionaryItem(id: 1, value_RO: 'Altele'),
    GenericDictionaryItem(id: 2, value_RO: 'Cosmetica'),
    GenericDictionaryItem(id: 3, value_RO: 'HairStyle'),
  ];

  CompanyFilter _getFilter() {
    return CompanyFilter(
        name: '',
        idCounty: _selectedCounty != null ? _selectedCounty.id : null,
        idCity: _selectedCity != null ? _selectedCity.id : null,
        idCategory: _selectedCategory != null ? _selectedCategory.id : null,
        idSubCategory:
            _selectedSubCategory != null ? _selectedSubCategory.id : null);
  }

  bool _filterExists() {
    bool exists = false;
    if (_selectedCounty != null ||
        _selectedCity != null ||
        _selectedCategory != null ||
        _selectedSubCategory != null) exists = true;

    return exists;
  }

  void _clearFilters() {
    setState(() {
      _selectedCounty = null;
      _selectedCity = null;
      _selectedCategory = null;
      _selectedSubCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtre companie'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<County>(
                      isDense: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                      ),
                      hint: Text('Judet'),
                      value: _selectedCounty,
                      items: _counties.map((county) {
                        return new DropdownMenuItem<County>(
                          value: county,
                          child: new Text(county.name),
                        );
                      }).toList(),
                      onChanged: (County newValue) {
                        setState(() {
                          _selectedCounty = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<City>(
                      isDense: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                      ),
                      hint: Text('Localitate'),
                      value: _selectedCity,
                      items: _cities.map((city) {
                        return new DropdownMenuItem<City>(
                          value: city,
                          child: new Text(city.name),
                        );
                      }).toList(),
                      onChanged: (City newValue) {
                        setState(() {
                          _selectedCity = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<GenericDictionaryItem>(
                      isDense: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                      ),
                      hint: Text('Categorie'),
                      value: _selectedCategory,
                      items: _categories.map((category) {
                        return new DropdownMenuItem<GenericDictionaryItem>(
                          value: category,
                          child: new Text(category.value_RO),
                        );
                      }).toList(),
                      onChanged: (GenericDictionaryItem newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<GenericDictionaryItem>(
                      isDense: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                      ),
                      hint: Text('Subcategorie'),
                      value: _selectedSubCategory,
                      items: _subCategories.map((subcategory) {
                        return new DropdownMenuItem<GenericDictionaryItem>(
                          value: subcategory,
                          child: new Text(subcategory.value_RO),
                        );
                      }).toList(),
                      onChanged: (GenericDictionaryItem newValue) {
                        setState(() {
                          _selectedSubCategory = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(Icons.done),
                  label: Text('Aplica filtre'),
                  onPressed: () {
                    Navigator.of(context).pop<CompanyFilter>(_getFilter());
                  },
                  elevation: 1,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                ),
                if(_filterExists()) RaisedButton.icon(
                  onPressed: () {
                    _clearFilters();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Sterge filtre'),
                  elevation: 1,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
