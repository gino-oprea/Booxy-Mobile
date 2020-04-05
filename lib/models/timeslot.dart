import 'package:intl/intl.dart';

import './booking.dart';

class Timeslot {
  DateTime startTime;
  DateTime endTime;
  bool isSelectable;
  bool isSelected;
  List<Booking> bookings;
  bool isBooked;
  bool isFullBooked;
  bool hasFilteredBooking;

  Timeslot(
      {this.startTime,
      this.endTime,
      this.isSelectable,
      this.isSelected,
      this.bookings,
      this.isBooked,
      this.isFullBooked,
      this.hasFilteredBooking});

  Timeslot fromJson(Map json) {
    this.startTime =
        json['startTime'] == null ? null : DateTime.parse(json['startTime']);
    this.endTime =
        json['endTime'] == null ? null : DateTime.parse(json['endTime']);
    this.isSelectable = json['isSelectable'];
    this.isSelected = json['isSelected'];
    //this.bookings=json['bookings']
    this.isBooked = json['isBooked'];
    this.isFullBooked = json['isFullBooked'];
    this.hasFilteredBooking = json['hasFilteredBooking'];

    this.bookings = new List<Booking>();
    List<dynamic> rawBookings = json['bookings'];
    for (int i = 0; i < rawBookings.length; i++) {
      var bookingMap = rawBookings[i];
      var booking = new Booking().fromJson(bookingMap);

      bookings.add(booking);
    }

    return this;
  }

  Map toJson() {
    Map obj = {
      'startTime': DateFormat('yyyy-MM-dd hh:mm').format(this.startTime),
      'endTime': DateFormat('yyyy-MM-dd hh:mm').format(this.endTime),
      'isSelectable': this.isSelectable,
      'isSelected': this.isSelected,
      'bookings': this.bookings != null
          ? this.bookings.map((b) => b.toJson()).toList()
          : null,
      'isBooked': this.isBooked,
      'isFullBooked': this.isFullBooked,
      'hasFilteredBooking': this.hasFilteredBooking
    };

    return obj;
  }
}
