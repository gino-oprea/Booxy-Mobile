import '../providers/login-provider.dart';
import '../screens/login-screen.dart';

import '../screens/my-account-screen.dart';
import '../screens/my-bookings-screen.dart';
import '../screens/my-companies-screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    LoginProvider().isAuth.then((auth) {
      setState(() {
        this.isAuth = auth;
      });
    });
  }

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
            if (!this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
                leading: Icon(Icons.perm_identity),
                title: Text('Login'),
              ),
            if (this.isAuth) Divider(),
            if (this.isAuth)
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
            if (this.isAuth) Divider(),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(MyBookingsScreen.routeName);
                },
                leading: Icon(Icons.access_time),
                title: Text('Programari'),
              ),
            if (this.isAuth) Divider(),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(MyCompaniesScreen.routeName);
                },
                leading: Icon(Icons.business),
                title: Text('Companiile mele'),
              ),
            if (this.isAuth)
              Divider(
                thickness: 1.0,
              ),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  LoginProvider().logout();
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
              ),
          ],
        ),
      ),
    );
  }
}
