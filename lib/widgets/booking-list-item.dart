import 'dart:convert';
import '../screens/my-booking-details-screen.dart';
import 'package:intl/intl.dart';

import '../models/booking.dart';
import 'package:flutter/material.dart';

class BookingListItem extends StatelessWidget {
  final Booking booking;

  BookingListItem(this.booking);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(MyBookingDetailsScreen.routeName, arguments: this.booking);
        },
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: booking.image.length > 0
              ? MemoryImage(base64Decode(booking.image[0].img))
              : NetworkImage(
                  'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png'),
          backgroundColor: Colors.transparent,
        ),
        title: Text(booking.companyName),
        subtitle: Text(DateFormat('dd-MMM-yyyy').format(booking.startDate) +
            ' ' +
            DateFormat('HH:mm').format(booking.startTime) +
            ' - ' +
            DateFormat('HH:mm').format(booking.endTime)),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.arrow_right)]),
        isThreeLine: true,
      ),
    );
  }
}
