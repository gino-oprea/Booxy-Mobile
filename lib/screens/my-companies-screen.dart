import 'package:flutter/material.dart';

class MyCompaniesScreen extends StatelessWidget {
  static String routeName = '/my-companies';

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
