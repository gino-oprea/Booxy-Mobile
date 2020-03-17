import '../models/company-filter.dart';

import './company-filters-screen.dart';

import '../widgets/company-list-item.dart';

import '../providers/companies-provider.dart';
import '../widgets/app-drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanySearchScreen extends StatefulWidget {
  static const routeName = '/company-search';

  @override
  _CompanySearchScreenState createState() => _CompanySearchScreenState();
}

class _CompanySearchScreenState extends State<CompanySearchScreen> {
  var _isInit = true;
  var _isLoading = false;
  CompanyFilter _advancedFilter = null;

  final _companyNameController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CompaniesProvider>(context).getCompanies().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _onSearchCompany(String companyName) {
    if (_advancedFilter == null)
      Provider.of<CompaniesProvider>(context)
          .getCompanies(_companyNameController.text);
    else
      Provider.of<CompaniesProvider>(context).getCompanies(
          _companyNameController.text,
          _advancedFilter.idCategory,
          _advancedFilter.idSubCategory,
          _advancedFilter.idCounty,
          _advancedFilter.idCity);
  }

  Future<void> _onRefresh(BuildContext ctx) async {
    if (_advancedFilter == null)
      await Provider.of<CompaniesProvider>(ctx)
          .getCompanies(_companyNameController.text);
    else
      Provider.of<CompaniesProvider>(context).getCompanies(
          _companyNameController.text,
          _advancedFilter.idCategory,
          _advancedFilter.idSubCategory,
          _advancedFilter.idCounty,
          _advancedFilter.idCity);
  }

  void _setAdvancedFilters(CompanyFilter filter) {
    if (filter.idCounty == null &&
        filter.idCity == null &&
        filter.idCategory == null &&
        filter.idSubCategory == null)
      this._advancedFilter = null;
    else
      this._advancedFilter = CompanyFilter(
          idCounty: filter.idCounty,
          idCity: filter.idCity,
          idCategory: filter.idCategory,
          idSubCategory: filter.idSubCategory);

    Provider.of<CompaniesProvider>(context).getCompanies(
        _companyNameController.text,
        filter.idCategory,
        filter.idSubCategory,
        filter.idCounty,
        filter.idCity);
  }

  @override
  Widget build(BuildContext context) {
    final companiesProvider = Provider.of<CompaniesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            textInputAction: TextInputAction.search,
            controller: _companyNameController,
            onSubmitted: _onSearchCompany,
            maxLines: 1,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              prefixIcon: Icon(Icons.search),
              hintText: 'Cauta companie',
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 1),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CompanyFiltersScreen.routeName,
                      arguments: _advancedFilter)
                  .then((flt) {
                _setAdvancedFilters(flt);
              });
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: Container(
                child: ListView.builder(
                    itemCount: companiesProvider.companies.length,
                    itemBuilder: (ctx, i) {
                      return CompanyListItem(companiesProvider.companies[i]);
                    }),
              ),
            ),
    );
  }
}
