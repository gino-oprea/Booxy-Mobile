import '../providers/categories-provider.dart';
import 'package:provider/provider.dart';
import '../providers/company-location-provider.dart';
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
  bool _isInit = true;

  County _selectedCounty;
  City _selectedCity;
  GenericDictionaryItem _selectedCategory;
  GenericDictionaryItem _selectedSubCategory;

  bool _useRouteArgs = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CompanyLocationProvider>(context, listen: false)
          .getCounties()
          .then((_) {
        Provider.of<CategoriesProvider>(context, listen: false)
            .getCategories()
            .then((_) {
          _getFilterFromArgs(context);
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  CompanyFilter _getFilter() {
    return CompanyFilter(
        name: '',
        idCounty: _selectedCounty != null ? _selectedCounty.id : null,
        idCity: _selectedCity != null ? _selectedCity.id : null,
        idCategory: _selectedCategory != null ? _selectedCategory.id : null,
        idSubCategory:
            _selectedSubCategory != null ? _selectedSubCategory.id : null);
  }

  void _getFilterFromArgs(BuildContext context) {
    var routeArgs = ModalRoute.of(context).settings.arguments as CompanyFilter;

    if (routeArgs != null) {
      _selectedCounty = Provider.of<CompanyLocationProvider>(context)
          .counties
          .firstWhere((c) => c.id == routeArgs.idCounty, orElse: () => null);
      _selectedCity = Provider.of<CompanyLocationProvider>(context)
          .cities
          .firstWhere((c) => c.id == routeArgs.idCity, orElse: () => null);
      _selectedCategory = Provider.of<CategoriesProvider>(context)
          .categories
          .firstWhere((c) => c.id == routeArgs.idCategory, orElse: () => null);
      _selectedSubCategory = Provider.of<CategoriesProvider>(context)
          .subCategories
          .firstWhere((c) => c.id == routeArgs.idSubCategory,
              orElse: () => null);
    }
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
    _selectedCounty = null;
    _selectedCity = null;
    _selectedCategory = null;
    _selectedSubCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    final companyLocationProvider =
        Provider.of<CompanyLocationProvider>(context);

    final categoriesProvider = Provider.of<CategoriesProvider>(context);

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
                      items: companyLocationProvider.counties.map((county) {
                        return new DropdownMenuItem<County>(
                          value: county,
                          child: new Text(county.name),
                        );
                      }).toList(),
                      onChanged: (County newValue) {
                        setState(() {
                          _selectedCounty = newValue;
                          companyLocationProvider.getCities(_selectedCounty.id);
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
                      items: companyLocationProvider.cities.map((city) {
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
                      items: categoriesProvider.categories.map((category) {
                        return new DropdownMenuItem<GenericDictionaryItem>(
                          value: category,
                          child: new Text(category.value_RO),
                        );
                      }).toList(),
                      onChanged: (GenericDictionaryItem newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                          categoriesProvider
                              .getSubcategories(_selectedCategory.id);
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
                      items:
                          categoriesProvider.subCategories.map((subcategory) {
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
                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0)),
                  label: Text('Aplica filtre'),
                  onPressed: () {
                    Navigator.of(context).pop<CompanyFilter>(_getFilter());
                  },
                  elevation: 1,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                ),
                if (_filterExists())
                  RaisedButton.icon(
                    onPressed: () {
                      _clearFilters();
                      Navigator.of(context).pop<CompanyFilter>(_getFilter());
                    },
                    icon: Icon(Icons.refresh),
                    shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0)),
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
