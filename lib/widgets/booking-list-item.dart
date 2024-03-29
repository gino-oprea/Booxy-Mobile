import 'dart:convert';
import '../base-widgets/base-stateful-widget.dart';
import '../screens/my-booking-details-screen.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import 'package:flutter/material.dart';

class BookingListItem extends BaseStatefulWidget {
  final Booking booking;
  dynamic memoryImage;
  Future<void> Function() onRefreshBookings;

  BookingListItem(this.booking, this.memoryImage, this.onRefreshBookings);

  @override
  _BookingListItemState createState() => _BookingListItemState([]);
}

class _BookingListItemState extends BaseState<BookingListItem> {
  _BookingListItemState(List<String> labelsKeys) : super(labelsKeys);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(MyBookingDetailsScreen.routeName,
                  arguments: this.widget.booking)
              .then((value) {
            widget.onRefreshBookings();
          });
        },
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: widget.memoryImage,
          // widget.booking.image.length > 0
          //     ? MemoryImage(base64Decode(widget.booking.image[0].img))
          //     : NetworkImage(
          //         'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png'),
          backgroundColor: Colors.transparent,
        ),
        title: Text(widget.booking.companyName),
        subtitle: Text(
            DateFormat('dd-MMM-yyyy').format(widget.booking.startDate) +
                ' ' +
                DateFormat('HH:mm').format(widget.booking.startTime) +
                ' - ' +
                DateFormat('HH:mm').format(widget.booking.endTime)),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.arrow_right)]),
        isThreeLine: true,
      ),
    );
  }
}
