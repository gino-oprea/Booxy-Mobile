import '../providers/booking-provider.dart';
import '../widgets/booking-list-item.dart';

import '../models/booking.dart';
import 'package:flutter/material.dart';

class MyBookingsScreen extends StatefulWidget {
  static String routeName = '/my-bookings';

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Booking> bookings = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programarile mele'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => loadBookings(),
              child: Container(
                child: bookings.length>0 ? ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (ctx, i) {
                      return BookingListItem(bookings[i]);
                    }): Text('Nu aveti programari active'),
              ),
            ),
    );
  }
}
