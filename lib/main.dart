import 'package:booxy/screens/company-search-screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booxy',
      theme: ThemeData(        
        primarySwatch: Colors.green,
        accentColor: Colors.deepOrange
      ),
      home: CompanySearchScreen(),
    );
  }
}


