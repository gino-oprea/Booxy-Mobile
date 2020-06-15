import 'package:booxy/base-widgets/base-stateful-widget.dart';

import '../models/booking.dart';
import '../providers/booking-provider.dart';
import 'package:flutter/material.dart';

class BookingStatusDialog extends BaseStatefulWidget {
  final Booking booking;

  BookingStatusDialog(this.booking);

  @override
  _BookingStatusDialogState createState() => _BookingStatusDialogState(
      ['lblChangeStatus', 'lblHonored', 'lblActive', 'lblCanceled']);
}

class _BookingStatusDialogState extends BaseState<BookingStatusDialog> {
  _BookingStatusDialogState(List<String> labelsKeys) : super(labelsKeys);

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
            Text(getCurrentLabelValue('lblChangeStatus')),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              child: Text(getCurrentLabelValue('lblHonored')),
              color: Colors.lightGreen,
              onPressed: () async {
                var gro =
                    await BookingProvider().setBookingStatus(widget.booking, 2);
                Navigator.of(context).pop(gro.error);
              },
            ),
            RaisedButton(
              child: Text(getCurrentLabelValue('lblActive')),
              color: Colors.blue,
              onPressed: () async {
                var gro =
                    await BookingProvider().setBookingStatus(widget.booking, 1);
                Navigator.of(context).pop(gro.error);
              },
            ),
            RaisedButton(
              child: Text(getCurrentLabelValue('lblCanceled')),
              color: Colors.grey,
              onPressed: () async {
                var gro =
                    await BookingProvider().cancelBooking(widget.booking.id);
                Navigator.of(context).pop(gro.error);
              },
            )
          ],
        ),
      ),
    );
  }
}
