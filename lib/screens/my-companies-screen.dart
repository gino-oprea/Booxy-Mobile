import '../models/company.dart';
import '../widgets/my-company-list-item.dart';

import '../providers/companies-provider.dart';
import '../providers/login-provider.dart';
import 'package:flutter/material.dart';

class MyCompaniesScreen extends StatefulWidget {
  static String routeName = '/my-companies';

  @override
  _MyCompaniesScreenState createState() => _MyCompaniesScreenState();
}

class _MyCompaniesScreenState extends State<MyCompaniesScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Company> companies = [];

  Future<void> _onRefresh(BuildContext ctx) async {
    var currentUser = await LoginProvider().currentUser;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Companiile mele'),
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
                            return MyCompanyListItem(this.companies[i]);
                          }),
                    )
                  : Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'Nu aveti companii. Puteti crea companie noua pe www.booxy.ro'),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            _onRefresh(context);
                          },
                        )
                      ],
                    )),
            ),
    );
  }
}
