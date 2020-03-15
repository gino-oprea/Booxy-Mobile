import 'package:flutter/material.dart';

class MyAccountScreen extends StatelessWidget {
  static const routeName = '/my-account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contul meu'),
      ),
      body: Text('Contul meu'),
    );
  }
}
