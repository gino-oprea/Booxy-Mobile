import 'package:flutter/material.dart';

class CompanyDetailsScreen extends StatelessWidget {
  static const routeName = '/company-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company details'),
      ),
      body: Text('Company details'),
    );
  }
}
