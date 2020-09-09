import 'dart:convert';

import '../base-widgets/base-stateful-widget.dart';

import '../dialogs/booking-status-dialog.dart';
import 'package:intl/intl.dart';

import '../models/booking.dart';
import 'package:flutter/material.dart';

enum BookingStatus { Active, Honored, Canceled }

class BookingListItemAdmin extends BaseStatefulWidget {
  final Booking booking;
  Future<void> Function() onReloadBookings;
  Map<int, dynamic> memoryImages;

  BookingListItemAdmin(this.booking, this.memoryImages, this.onReloadBookings);

  @override
  _BookingListItemAdminState createState() => _BookingListItemAdminState([]);
}

class _BookingListItemAdminState extends BaseState<BookingListItemAdmin> {
  _BookingListItemAdminState(List<String> labelsKeys) : super(labelsKeys);

  Text getStatusColored(int idStatus) {
    var color;
    if (idStatus == 1) color = Colors.blue;
    if (idStatus == 2) color = Colors.green;
    if (idStatus == 3) color = Colors.grey;

    return Text(
      BookingStatus.values[idStatus - 1].toString().split('.').last,
      style: TextStyle(color: color, fontSize: 20),
    );
  }

  List<Widget> generateEntitiesTxts() {
    List<Widget> wdgs = [];

    for (int i = 0; i < widget.booking.entities.length; i++) {
      //this.booking.entities.forEach((entity) {
      var entity = widget.booking.entities[i];
      var image = widget.memoryImages[entity
          .idEntity]; //await BooxyImageProvider().getEntityImage(entity.idEntity);

      var ddl = Column(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(5),
            child: FittedBox(
              child: image,
              // image != null
              //     ? Image.memory(base64Decode(image.img))
              //     : Icon(Icons.extension),
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
    return GestureDetector(
      onTap: () {
        showDialog(
                context: context,
                builder: (ctx) => BookingStatusDialog(widget.booking))
            .then((value) {
          if (value != null) if (value as String == '')
            widget.onReloadBookings();
          else
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text('Error'),
                      content: Text(value),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                        )
                      ],
                    ));
        });
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ...generateEntitiesTxts(),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                        DateFormat('dd-MMM-yyyy')
                            .format(widget.booking.startDate),
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.person,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                        widget.booking.firstName +
                            ' ' +
                            widget.booking.lastName,
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.access_time,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                        DateFormat('HH:mm').format(widget.booking.startTime) +
                            ' - ' +
                            DateFormat('HH:mm').format(widget.booking.endTime),
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.phone,
                      ),
                      onPressed: () {},
                    ),
                    Text(widget.booking.phone, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.slow_motion_video,
                      ),
                      onPressed: () {},
                    ),
                    getStatusColored(widget.booking.idStatus),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
