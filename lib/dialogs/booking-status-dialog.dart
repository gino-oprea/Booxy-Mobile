import '../models/booking.dart';
import '../providers/booking-provider.dart';
import 'package:flutter/material.dart';

class BookingStatusDialog extends StatelessWidget {
  final Booking booking;

  BookingStatusDialog(this.booking);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0.0,
      child: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Schimba statusul'),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              child: Text('Honored'),
              color: Colors.lightGreen,
              onPressed: () async {
                var gro = await BookingProvider().setBookingStatus(booking, 2);
                Navigator.of(context).pop(gro.error);
              },
            ),
            RaisedButton(
              child: Text('Active'),
              color: Colors.blue,
              onPressed: () async {
                var gro = await BookingProvider().setBookingStatus(booking, 1);
                Navigator.of(context).pop(gro.error);
              },
            ),
            RaisedButton(
              child: Text('Canceled'),
              color: Colors.grey,
              onPressed: () async {
                var gro = await BookingProvider().cancelBooking(booking.id);
                Navigator.of(context).pop(gro.error);
              },
            )
          ],
        ),
      ),
    );
  }
}
