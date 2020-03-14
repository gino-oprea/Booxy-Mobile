import 'package:provider/provider.dart';

import './screens/company-search-screen.dart';
import 'package:flutter/material.dart';
import './providers/companies-provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: CompaniesProvider([]),
      child: MaterialApp(
        title: 'Booxy',
        theme: ThemeData(
            primarySwatch: Colors.green, accentColor: Colors.deepOrange),
        home: CompanySearchScreen(),
      ),
    );
  }
}
