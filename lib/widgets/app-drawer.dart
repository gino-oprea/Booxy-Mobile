import 'package:booxy/screens/login-screen.dart';

import '../screens/my-account-screen.dart';
import '../screens/my-bookings-screen.dart';
import '../screens/my-companies-screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Booxy'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              leading: Icon(Icons.perm_identity),
              title: Text('Login'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(MyAccountScreen.routeName);
              },
              leading: Icon(Icons.account_circle),
              title: Text('Contul meu'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              leading: Icon(Icons.search),
              title: Text('Cauta companii'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(MyBookingsScreen.routeName);
              },
              leading: Icon(Icons.access_time),
              title: Text('Programari'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(MyCompaniesScreen.routeName);
              },
              leading: Icon(Icons.business),
              title: Text('Companiile mele'),
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
