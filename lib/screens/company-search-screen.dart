import 'package:booxy/enums/actions-enum.dart';
import 'package:booxy/providers/login-provider.dart';

import '../base-widgets/base-stateful-widget.dart';

import '../models/company-filter.dart';

import './company-filters-screen.dart';

import '../widgets/company-list-item.dart';

import '../providers/companies-provider.dart';
import '../widgets/app-drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanySearchScreen extends BaseStatefulWidget {
  static const routeName = '/company-search';

  @override
  _CompanySearchScreenState createState() =>
      _CompanySearchScreenState(['lblSearchCompany']);
}

class _CompanySearchScreenState extends BaseState<CompanySearchScreen> {
  var _isInit = true;
  var _isLoading = false;

  CompanyFilter _advancedFilter;

  final _companyNameController = TextEditingController();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  _CompanySearchScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Search company';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CompaniesProvider>(context).getCompanies().then((_) {
        setState(() {
          _isLoading = false;
        });

        logAction(
            this.idCompany, false, ActionsEnum.Search, '', 'Search company');
      });

      //delay ca sa apuce base-ul sa-si ia userul curent
      Future.delayed(Duration(seconds: 1), () {
        if (loginProvider.currentUser != null)
          Provider.of<CompaniesProvider>(context, listen: false)
              .getFavouriteCompaniesIds(); //nu mai e nevoie de set state pentru ca oricum se declanseaza notifyChanges
      });
    }

    _isInit = false;
  }

  void _onSearchCompany(String companyName) {
    if (_advancedFilter == null) {
      Provider.of<CompaniesProvider>(context)
          .getCompanies(_companyNameController.text);
      logAction(
          this.idCompany, false, ActionsEnum.Search, '', 'Search company');
    } else {
      Provider.of<CompaniesProvider>(context).getCompanies(
          _companyNameController.text,
          _advancedFilter.idCategory,
          _advancedFilter.idSubCategory,
          _advancedFilter.idCounty,
          _advancedFilter.idCity);
      logAction(this.idCompany, false, ActionsEnum.Search, '',
          'Search company advanced filters');
    }
  }

  Future<void> _onRefresh(BuildContext ctx) async {
    if (_advancedFilter == null) {
      await Provider.of<CompaniesProvider>(ctx)
          .getCompanies(_companyNameController.text);
      logAction(
          this.idCompany, false, ActionsEnum.Search, '', 'Search company');
    } else {
      Provider.of<CompaniesProvider>(context).getCompanies(
          _companyNameController.text,
          _advancedFilter.idCategory,
          _advancedFilter.idSubCategory,
          _advancedFilter.idCounty,
          _advancedFilter.idCity);
      logAction(this.idCompany, false, ActionsEnum.Search, '',
          'Search company advanced filters');
    }
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
    logAction(this.idCompany, false, ActionsEnum.Search, '',
        'Search company advanced filters');
  }

  showPageMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    print('build search screen');
    return Scaffold(
      key: _scaffoldKey,
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
              hintText: this.getCurrentLabelValue('lblSearchCompany'),
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
                      return CompanyListItem(
                          companiesProvider.companies[i],
                          loginProvider.currentUser != null,
                          companiesProvider
                              .isFavourite(companiesProvider.companies[i].id),
                          showPageMessage);
                    }),
              ),
            ),
    );
  }
}
