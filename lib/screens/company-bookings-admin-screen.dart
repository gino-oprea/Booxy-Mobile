import '../models/company.dart';

import './company-booking-admin-tab-screen.dart';
import 'package:flutter/material.dart';

class CompanyBookingsAdminScreen extends StatefulWidget {
  static String routeName = '/company-bookings';

  @override
  _CompanyBookingsAdminScreenState createState() =>
      _CompanyBookingsAdminScreenState();
}

class _CompanyBookingsAdminScreenState
    extends State<CompanyBookingsAdminScreen> {
  List<Widget> _pages;
  int _selectedPageIndex = 0;
  bool _isInit = true;
  Company company;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this.company = ModalRoute.of(context).settings.arguments as Company;

      _pages = [
        CompanyBookingAdminTabScreen(this.company, 'all'),
        CompanyBookingAdminTabScreen(this.company, 'today')
      ];
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programarile companiei'),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.history),
              title: Text('Toate')),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.today),
              title: Text('Astazi')),
        ],
      ),
    );
  }
}
