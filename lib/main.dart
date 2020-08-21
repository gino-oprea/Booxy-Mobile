import 'dart:async';

import 'package:booxy/providers/culture-provider.dart';
import 'package:booxy/screens/change-password-screen.dart';
import 'package:booxy/screens/favourite-companies-screen.dart';
import 'package:booxy/screens/register-screen.dart';

import './screens/company-bookings-admin-screen.dart';

import './providers/login-provider.dart';

import './screens/my-booking-details-screen.dart';

import './screens/login-screen.dart';

import './screens/company-booking-screen.dart';
import './providers/categories-provider.dart';
import './providers/company-location-provider.dart';
import './screens/company-filters-screen.dart';
import './screens/company-details-screen.dart';
import './screens/my-account-screen.dart';
import './screens/my-bookings-screen.dart';
import './screens/my-companies-screen.dart';
import 'package:provider/provider.dart';
import './screens/company-search-screen.dart';
import 'package:flutter/material.dart';
import './providers/companies-provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LoginProvider().autoLogin();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CompaniesProvider([])),
        ChangeNotifierProvider.value(value: CompanyLocationProvider([], [])),
        ChangeNotifierProvider.value(value: CategoriesProvider([], [])),
        //ChangeNotifierProvider.value(value: CultureProvider('RO')),
        ChangeNotifierProvider.value(value: LoginProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Booxy',
          theme: ThemeData(
              primarySwatch: Colors.green, accentColor: Colors.deepOrange),
          home: CompanySearchScreen(),
          routes: {
            CompanySearchScreen.routeName: (ctx) => CompanySearchScreen(),
            FavouriteCompaniesScreen.routeName: (ctx) =>
                FavouriteCompaniesScreen(),
            CompanyDetailsScreen.routeName: (ctx) => CompanyDetailsScreen(),
            MyAccountScreen.routeName: (ctx) => MyAccountScreen(),
            MyBookingsScreen.routeName: (ctx) => MyBookingsScreen(),
            MyCompaniesScreen.routeName: (ctx) => MyCompaniesScreen(),
            CompanyFiltersScreen.routeName: (ctx) => CompanyFiltersScreen(),
            CompanyBookingScreen.routeName: (ctx) => CompanyBookingScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
            RegisterScreen.routeName: (ctx) => RegisterScreen(),
            MyBookingDetailsScreen.routeName: (ctx) => MyBookingDetailsScreen(),
            CompanyBookingsAdminScreen.routeName: (ctx) =>
                CompanyBookingsAdminScreen()
          },
        ),
      ),
    );
  }
}
