import 'dart:convert';

import 'package:booxy/base-widgets/base-stateful-widget.dart';
import 'package:booxy/enums/actions-enum.dart';
import 'package:booxy/models/company.dart';
import 'package:booxy/providers/companies-provider.dart';
import 'package:booxy/widgets/company-list-item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteCompaniesScreen extends BaseStatefulWidget {
  static const routeName = '/favourite-companies';

  @override
  _FavouriteCompaniesScreenState createState() =>
      _FavouriteCompaniesScreenState(['lblFavourites']);
}

class _FavouriteCompaniesScreenState
    extends BaseState<FavouriteCompaniesScreen> {
  var _isInit = true;
  var _isLoading = false;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Company> favouriteCompanies = [];

  _FavouriteCompaniesScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Favourite companies';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      getFavouriteCompanies(context).then((result) {
        //setState(() {
        this.favouriteCompanies = result;
        _isLoading = false;
        //});
      });
    }

    _isInit = false;
  }

  showPageMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext ctx) async {
    this.favouriteCompanies = await getFavouriteCompanies(ctx);
    logAction(this.idCompany, false, ActionsEnum.Search, '', 'Search company');
  }

  Future<List<Company>> getFavouriteCompanies(BuildContext ctx) async {
    await Provider.of<CompaniesProvider>(ctx).getFavouriteCompaniesIds();
    logAction(this.idCompany, false, ActionsEnum.Search, '',
        'Get favourite companies');
    var fav = Provider.of<CompaniesProvider>(ctx).favouritesIds;
    List<Company> favComps = Provider.of<CompaniesProvider>(ctx)
        .companies
        .where((c) => fav.contains(c.id))
        .toList();

    return favComps;
  }

  dynamic getCompanyMemoryImage(Company company) {
    return company.image.length > 0
        ? MemoryImage(base64Decode(company.image[0].img))
        : NetworkImage(
            'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png');
  }

  @override
  Widget build(BuildContext context) {
    final companiesProvider = Provider.of<CompaniesProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(getCurrentLabelValue('lblFavourites')),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: Container(
                child: ListView.builder(
                    itemCount: this.favouriteCompanies.length,
                    itemBuilder: (ctx, i) {
                      return CompanyListItem(
                          this.favouriteCompanies[i],
                          loginProvider.currentUser != null,
                          companiesProvider
                              .isFavourite(this.favouriteCompanies[i].id),
                          getCompanyMemoryImage(this.favouriteCompanies[i]),
                          showPageMessage);
                    }),
              ),
            ),
    );
  }
}
