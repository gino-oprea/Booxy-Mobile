import 'package:flutter/material.dart';

class CompanyBookingScreen extends StatefulWidget {
  static const String routeName = '/company-booking';

  @override
  _CompanyBookingScreenState createState() => _CompanyBookingScreenState();
}

class _CompanyBookingScreenState extends State<CompanyBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programare'),
      ),
      body: Text('Programare'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Salveaza'),
        icon: Icon(Icons.check),
      ),
    );
  }
}
