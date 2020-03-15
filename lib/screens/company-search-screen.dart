import 'dart:convert';

import 'package:booxy/widgets/company-list-item.dart';

import '../providers/companies-provider.dart';
import 'package:booxy/widgets/app-drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanySearchScreen extends StatefulWidget {
  @override
  _CompanySearchScreenState createState() => _CompanySearchScreenState();
}

class _CompanySearchScreenState extends State<CompanySearchScreen> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CompaniesProvider>(context).getCompanies();
    }
    _isInit = false;

    super.didChangeDependencies();
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
            onPressed: null,
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        child: ListView.builder(
            itemCount: companiesProvider.companies.length,
            itemBuilder: (ctx, i) {
              return CompanyListItem(companiesProvider.companies[i]);
            }),
      ),
    );
  }
}
