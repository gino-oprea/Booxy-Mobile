import 'dart:convert';
import '../base-widgets/base-stateful-widget.dart';
import '../providers/booking-provider.dart';
import '../providers/booxy-image-provider.dart';
import 'package:intl/intl.dart';

import '../models/booking.dart';
import 'package:flutter/material.dart';

class MyBookingDetailsScreen extends BaseStatefulWidget {
  static const routeName = '/my-booking-details';

  @override
  _MyBookingDetailsScreenState createState() => _MyBookingDetailsScreenState([
        'lblMyBooking',
        'lblAddress',
        'lblPhone',
        'lblDate',
        'lblHour',
        'lblConfirmation',
        'lblYes',
        'lblNo',
        'lblConfirmCancelBooking',
        'lblCancelBooking',
        'lblBookingCanceled'
      ]);
}

class _MyBookingDetailsScreenState extends BaseState<MyBookingDetailsScreen> {
  bool _isInit = true;
  Booking booking;
  List<Widget> entitiesTxts;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  _MyBookingDetailsScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'My booking details';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this.booking = ModalRoute.of(context).settings.arguments as Booking;
      this.generateEntitiesTxts().then((w) {
        setState(() {
          this.entitiesTxts = w;
        });
      });
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Widget>> generateEntitiesTxts() async {
    List<Widget> wdgs = [];

    for (int i = 0; i < this.booking.entities.length; i++) {
      //this.booking.entities.forEach((entity) {
      var entity = this.booking.entities[i];
      var image = await BooxyImageProvider().getEntityImage(entity.idEntity);

      var ddl = Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(5),
            child: FittedBox(
              child: image != null
                  ? Image.memory(base64Decode(image.img))
                  : Icon(Icons.extension),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          // Expanded(
          // child:
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              entity.entityName_RO,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // ),
        ],
      );

      wdgs.add(ddl);
    }

    return wdgs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(getCurrentLabelValue('lblMyBooking')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            getCurrentLabelValue('lblAddress') + ': ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              this.booking.companyAddress,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Email: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            this.booking.companyEmail,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            getCurrentLabelValue('lblPhone') + ': ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            this.booking.companyPhone,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      if (entitiesTxts != null) ...entitiesTxts,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    getCurrentLabelValue('lblDate') + ': ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('dd-MMM-yyyy')
                                        .format(this.booking.startDate),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    getCurrentLabelValue('lblHour') + ': ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('HH:mm')
                                            .format(this.booking.startTime) +
                                        ' - ' +
                                        DateFormat('HH:mm')
                                            .format(this.booking.endTime),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text(getCurrentLabelValue('lblConfirmation')),
                    content:
                        Text(getCurrentLabelValue('lblConfirmCancelBooking')),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(getCurrentLabelValue('lblNo')),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text(getCurrentLabelValue('lblYes')),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);

                          BookingProvider()
                              .cancelBooking(this.booking.id)
                              .then((gro) {
                            if (gro.error != '')
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(gro.error),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            else
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(getCurrentLabelValue(
                                      'lblBookingCanceled')),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            Future.delayed(const Duration(milliseconds: 2000),
                                () {
                              Navigator.of(context).pop();
                            });
                          });
                        },
                      ),
                    ],
                  ));
        },
        label: Text(getCurrentLabelValue('lblCancelBooking')),
        icon: Icon(Icons.delete),
      ),
    );
  }
}
