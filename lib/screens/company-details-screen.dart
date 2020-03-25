import 'dart:convert';
import './company-booking-screen.dart';
import '../providers/working-hours-provider.dart';
import '../models/working-hours.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/company.dart';
import 'package:flutter/material.dart';

class CompanyDetailsScreen extends StatelessWidget {
  static const routeName = '/company-details';

  String getWorkingHoursString(String rawWH) {
    if (rawWH.isNotEmpty) {
      String whString = "";
      String aux = rawWH.substring(1, rawWH.length - 1);

      whString = aux.replaceAll(',', ' - ');
      return whString;
    } else
      return "-";
  }

  Column _generateScheduleWidgets(WorkingHours wh) {
    List<Widget> daysSchedule = [];

    var txt = Text(
      'Luni: ' + getWorkingHoursString(wh.monday.workHours),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
    daysSchedule.add(txt);

    txt = Text(
      'Marti: ' + getWorkingHoursString(wh.tuesday.workHours),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
    daysSchedule.add(txt);

    txt = Text(
      'Miercuri: ' + getWorkingHoursString(wh.wednesday.workHours),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
    daysSchedule.add(txt);

    txt = Text(
      'Joi: ' + getWorkingHoursString(wh.thursday.workHours),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
    daysSchedule.add(txt);

    txt = Text(
      'Vineri: ' + getWorkingHoursString(wh.friday.workHours),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
    daysSchedule.add(txt);

    txt = Text(
      'Sambata: ' + getWorkingHoursString(wh.saturday.workHours),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
    daysSchedule.add(txt);

    txt = Text(
      'Duminica: ' + getWorkingHoursString(wh.sunday.workHours),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
    daysSchedule.add(txt);

    var col = Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: daysSchedule);

    return col;
  }

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
              height: 200,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(company.lat, company.lng), zoom: 16),
                mapType: MapType.normal,
                markers: {
                  Marker(
                      markerId: MarkerId('m1'),
                      position: LatLng(company.lat, company.lng)),
                },
              ),
              // Image.network(
              //   GoogleMapsHelper.generateLocationPreviewImage(
              //       latitude: company.lat, longitude: company.lng),
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              // ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Adresa: ' + company.address,
                        textAlign: TextAlign.left,
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
                        textAlign: TextAlign.left,
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
                        textAlign: TextAlign.left,
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
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Ore de program: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FutureBuilder<WorkingHours>(
                    future: WorkingHoursProvider()
                        .getCompanyWorkingHours(company.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.error != null) {
                          // ...
                          // Do error handling stuff
                          return Center(
                            child: Text('An error occurred!'),
                          );
                        } else {
                          return _generateScheduleWidgets(snapshot.data);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(CompanyBookingScreen.routeName, arguments: company);
        },
        label: Text('Programeaza acum'),
        icon: Icon(Icons.thumb_up),
      ),
    );
  }
}
