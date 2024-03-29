import 'package:booxy/enums/actions-enum.dart';
import 'package:booxy/screens/change-password-screen.dart';
import 'package:booxy/screens/company-search-screen.dart';
import 'package:booxy/screens/favourite-companies-screen.dart';
import 'package:booxy/screens/register-screen.dart';

import '../base-widgets/base-stateful-widget.dart';
import '../dialogs/lang-picker-dialog.dart';

import '../providers/login-provider.dart';
import '../screens/login-screen.dart';

import '../screens/my-account-screen.dart';
import '../screens/my-bookings-screen.dart';
import '../screens/my-companies-screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends BaseStatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState([
        'lblMyAccount',
        'lblLanguage',
        'lblSearchCompany',
        'lblBookings',
        'lblMyCompanies',
        'lblRegister',
        'lblChangePassword',
        'lblFavourites'
      ]);
}

class _AppDrawerState extends BaseState<AppDrawer> {
  _AppDrawerState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'App drawer';
  }

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
            if (!this.isAuth) Divider(),
            if (!this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(RegisterScreen.routeName);
                },
                leading: Icon(Icons.perm_identity),
                title: Text(getCurrentLabelValue('lblRegister')),
              ),
            if (!this.isAuth) Divider(),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(MyAccountScreen.routeName);
                },
                leading: Icon(Icons.account_circle),
                title: Text(getCurrentLabelValue('lblMyAccount')),
              ),
            if (this.isAuth) Divider(),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ChangePasswordScreen.routeName);
                },
                leading: Icon(Icons.lock),
                title: Text(getCurrentLabelValue('lblChangePassword')),
              ),
            if (this.isAuth) Divider(),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) => LangPickerDialog()).then((value) {
                  //this.currentCulture = value;
                  //this.setCurrentCulture();
                });
              },
              leading: Icon(Icons.language),
              title: Text(getCurrentLabelValue('lblLanguage')),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(CompanySearchScreen.routeName);
              },
              leading: Icon(Icons.search),
              title: Text(getCurrentLabelValue('lblSearchCompany')),
            ),
            if (this.isAuth) Divider(),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(FavouriteCompaniesScreen.routeName);
                },
                leading: Icon(Icons.favorite),
                title: Text(getCurrentLabelValue('lblFavourites')),
              ),
            if (this.isAuth) Divider(),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(MyBookingsScreen.routeName);
                },
                leading: Icon(Icons.access_time),
                title: Text(getCurrentLabelValue('lblBookings')),
              ),
            if (this.isAuth) Divider(),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(MyCompaniesScreen.routeName);
                },
                leading: Icon(Icons.business),
                title: Text(getCurrentLabelValue('lblMyCompanies')),
              ),
            if (this.isAuth)
              Divider(
                thickness: 1.0,
              ),
            if (this.isAuth)
              ListTile(
                onTap: () {
                  logAction(this.idCompany, false, ActionsEnum.Logout, '', '');
                  loginProvider.logout().then((_) {
                    loginProvider.loginChange();
                  });
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
