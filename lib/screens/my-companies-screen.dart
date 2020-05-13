import 'package:flutter/material.dart';

class MyCompaniesScreen extends StatefulWidget {
  static String routeName = '/my-companies';

  @override
  _MyCompaniesScreenState createState() => _MyCompaniesScreenState();
}

class _MyCompaniesScreenState extends State<MyCompaniesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Companiile mele'),
      ),
      body: Text('Companiile mele'),
    );
  }
}
