import 'dart:convert';

import '../base-widgets/base-stateful-widget.dart';
import '../providers/booking-provider.dart';
import '../widgets/booking-list-item.dart';
import '../models/booking.dart';
import 'package:flutter/material.dart';

class MyBookingsScreen extends BaseStatefulWidget {
  static String routeName = '/my-bookings';

  @override
  _MyBookingsScreenState createState() =>
      _MyBookingsScreenState(['lblMyBookings', 'lblNoActiveBookings']);
}

class _MyBookingsScreenState extends BaseState<MyBookingsScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Booking> bookings = [];

  _MyBookingsScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'My bookings';
  }

  @override
  void didChangeDependencies() {
    if (this._isInit) {
      setState(() {
        this._isLoading = true;
        //start loading bookings
        BookingProvider().getCurrentUserBookings().then((gro) {
          setState(() {
            this.bookings = gro.objList as List<Booking>;
            _isLoading = false;
          });
        });
      });
    }

    this._isInit = false;

    super.didChangeDependencies();
  }

  Future<void> loadBookings() async {
    var gro = await BookingProvider().getCurrentUserBookings();
    setState(() {
      this.bookings = gro.objList as List<Booking>;
    });
  }

  // void reloadBookings() {
  //   BookingProvider().getCurrentUserBookings().then((gro) {
  //     setState(() {
  //       this.bookings = gro.objList as List<Booking>;
  //     });
  //   });
  // }

  dynamic getBookingMemoryImage(Booking booking) {
    return booking.image.length > 0
        ? MemoryImage(base64Decode(booking.image[0].img))
        : NetworkImage(
            'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getCurrentLabelValue('lblMyBookings')),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => loadBookings(),
              child: bookings.length > 0
                  ? Container(
                      child: ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (ctx, i) {
                            return BookingListItem(
                                bookings[i],
                                getBookingMemoryImage(bookings[i]),
                                loadBookings);
                          }))
                  : Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(getCurrentLabelValue('lblNoActiveBookings')),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: loadBookings,
                        )
                      ],
                    ))),
    );
  }
}
