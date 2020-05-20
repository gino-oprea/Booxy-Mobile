import 'dart:convert';

import '../screens/company-bookings-admin-screen.dart';

import '../models/company.dart';
import 'package:flutter/material.dart';

class MyCompanyListItem extends StatelessWidget {
  final Company company;

  MyCompanyListItem(this.company);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(CompanyBookingsAdminScreen.routeName, arguments: company);
        },
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: company.image.length > 0
              ? MemoryImage(base64Decode(company.image[0].img))
              : NetworkImage(
                  'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png'),
          backgroundColor: Colors.transparent,
        ),
        title: Text(company.name),
        subtitle: Text(company.address),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.arrow_right)]),
        isThreeLine: true,
      ),
    );
  }
}
