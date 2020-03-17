import 'dart:convert';

import '../helpers/google-maps-helper.dart';

import '../models/company.dart';
import 'package:flutter/material.dart';

class CompanyDetailsScreen extends StatelessWidget {
  static const routeName = '/company-details';

  @override
  Widget build(BuildContext context) {
    final Company company =
        ModalRoute.of(context).settings.arguments as Company;

    final appBar = AppBar(
      title: Text(
        company.name,
        textAlign: TextAlign.center,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: double.infinity,
              child: Image.network(
                GoogleMapsHelper.generateLocationPreviewImage(
                    latitude: company.lat, longitude: company.lng),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  child: company.image.length > 0
                      ? Image.memory(
                          base64Decode(company.image[0].img),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.network(
                          'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Adresa: ' + company.address,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Telefon: ' + company.phone,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Email: ' + company.email,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Programeaza acum'),
        icon: Icon(Icons.thumb_up),
      ),
    );
  }
}
