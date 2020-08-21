import 'dart:convert';

import '../base-widgets/base-stateful-widget.dart';

import '../models/company.dart';
import '../widgets/my-company-list-item.dart';

import '../providers/companies-provider.dart';
import '../providers/login-provider.dart';
import 'package:flutter/material.dart';

class MyCompaniesScreen extends BaseStatefulWidget {
  static String routeName = '/my-companies';

  @override
  _MyCompaniesScreenState createState() =>
      _MyCompaniesScreenState(['lblMyCompanies', 'lblNoCompaniesPleaseCreate']);
}

class _MyCompaniesScreenState extends BaseState<MyCompaniesScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Company> companies = [];

  _MyCompaniesScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'My Companies';
  }

  Future<void> _onRefresh(BuildContext ctx) async {
    var currentUser = await LoginProvider().currentUserProp;
    var gro = await CompaniesProvider(null).getMyCompanies(currentUser.id);
    setState(() {
      this.companies = gro.objList as List<Company>;
      this._isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (this._isInit) {
      this._isLoading = true;
      this._onRefresh(context);
    }

    this._isInit = false;
    super.didChangeDependencies();
  }
  
  dynamic getCompanyMemoryImage(Company company) {
    return company.image.length > 0
        ? MemoryImage(base64Decode(company.image[0].img))
        : NetworkImage(
            'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getCurrentLabelValue('lblMyCompanies')),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: this.companies.length > 0
                  ? Container(
                      child: ListView.builder(
                          itemCount: this.companies.length,
                          itemBuilder: (ctx, i) {
                            return MyCompanyListItem(this.companies[i], getCompanyMemoryImage(this.companies[i]));
                          }),
                    )
                  : Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getCurrentLabelValue(
                                'lblNoCompaniesPleaseCreate')),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            _onRefresh(context);
                          },
                        ),
                      ],
                    )),
            ),
    );
  }
}
