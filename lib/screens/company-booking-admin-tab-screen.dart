import '../models/company.dart';

import '../providers/booking-provider.dart';

import '../models/booking.dart';
import '../widgets/booking-list-item-admin.dart';
import 'package:flutter/material.dart';

class CompanyBookingAdminTabScreen extends StatefulWidget {
  final String type;
  final Company company;

  CompanyBookingAdminTabScreen(this.company, this.type);

  @override
  _CompanyBookingAdminTabScreenState createState() =>
      _CompanyBookingAdminTabScreenState();
}

class _CompanyBookingAdminTabScreenState
    extends State<CompanyBookingAdminTabScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Booking> bookings = [];
  List<Booking> todayBookings = [];

  @override
  void didChangeDependencies() {
    if (this._isInit) {
      //setState(() {
      this._isLoading = true;
      //start loading bookings
      loadBookings();
      //});
    }

    this._isInit = false;

    super.didChangeDependencies();
  }

  Future<void> loadBookings() async {
    var gro = await BookingProvider().getCompanyBookings(widget.company.id);
    setState(() {
      this.bookings = gro.objList as List<Booking>;
      this.todayBookings = this.bookings.where((b) {
        if (b.startDate.day == DateTime.now().day &&
            b.startDate.month == DateTime.now().month &&
            b.startDate.year == DateTime.now().year) return true;

        return false;
      }).toList();

      this._isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bks = (widget.type == 'today') ? todayBookings : bookings;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () => loadBookings(),
            child: bks.length > 0
                ? Container(
                    child: ListView.builder(
                        itemCount: bks.length,
                        itemBuilder: (ctx, i) {
                          return BookingListItemAdmin(bks[i], loadBookings);
                        }))
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.type == 'all'
                          ? Text('Nu aveti programari')
                          : Text('Nu aveti programari astazi'),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: loadBookings,
                      )
                    ],
                  )));
  }
}