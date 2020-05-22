import '../dialogs/booking-status-dialog.dart';
import 'package:intl/intl.dart';

import '../models/booking.dart';
import 'package:flutter/material.dart';

enum BookingStatus { Active, Honored, Canceled }

class BookingListItemAdmin extends StatefulWidget {
  final Booking booking;
  Future<void> Function() onReloadBookings;

  BookingListItemAdmin(this.booking, this.onReloadBookings);

  @override
  _BookingListItemAdminState createState() => _BookingListItemAdminState();
}

class _BookingListItemAdminState extends State<BookingListItemAdmin> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
                context: context,
                builder: (ctx) => BookingStatusDialog(widget.booking))
            .then((value) {
          if (value != null) 
            if (value as String == '')
              widget.onReloadBookings();
            else
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Eroare'),
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
                        Icons.extension,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                        widget.booking.entities
                            .map((e) => e.entityName_RO)
                            .join(' - '),
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
