import 'package:booxy/screens/company-details-screen.dart';
import 'package:provider/provider.dart';

import './screens/company-search-screen.dart';
import 'package:flutter/material.dart';
import './providers/companies-provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: CompaniesProvider([]))],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Booxy',
          theme: ThemeData(
              primarySwatch: Colors.green, accentColor: Colors.deepOrange),
          home: CompanySearchScreen(),
          routes: {CompanyDetailsScreen.routeName: (ctx) => CompanyDetailsScreen()},
        ),
      ),
    );
  }
}
