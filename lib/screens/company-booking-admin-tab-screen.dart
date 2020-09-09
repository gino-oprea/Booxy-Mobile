import 'dart:convert';

import 'package:booxy/models/booxy-image.dart';
import 'package:booxy/providers/booxy-image-provider.dart';

import '../base-widgets/base-stateful-widget.dart';

import '../models/company.dart';

import '../providers/booking-provider.dart';

import '../models/booking.dart';
import '../widgets/booking-list-item-admin.dart';
import 'package:flutter/material.dart';

class CompanyBookingAdminTabScreen extends BaseStatefulWidget {
  final String type;
  final Company company;

  CompanyBookingAdminTabScreen(this.company, this.type);

  @override
  _CompanyBookingAdminTabScreenState createState() =>
      _CompanyBookingAdminTabScreenState(
          ['lblNoBookings', 'lblNoBookingsToday']);
}

class _CompanyBookingAdminTabScreenState
    extends BaseState<CompanyBookingAdminTabScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Booking> bookings = [];
  List<Booking> todayBookings = [];
  //Map<int, BooxyImage> entityImages = new Map();

  _CompanyBookingAdminTabScreenState(List<String> labelsKeys)
      : super(labelsKeys) {
    this.widgetName = "Company bookings admin";
  }

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

    this.idCompany = widget.company.id;

    super.didChangeDependencies();
  }

  Future<void> loadBookings() async {
    var gro = await BookingProvider().getCompanyBookings(widget.company.id);

    this.bookings = gro.objList as List<Booking>;
    // this.entityImages = new Map<int, BooxyImage>();

    for (int i = 0; i < this.bookings.length; i++) {
      for (int j = 0; j < this.bookings[i].entities.length; j++) {
        var entImage = await BooxyImageProvider()
            .getEntityImage(this.bookings[i].entities[j].idEntity);
        this.bookings[i].entities[j].images.add(entImage);
        // this.entityImages[this.bookings[i].entities[j].idEntity] = entImage;
      }
    }

    setState(() {
      this.todayBookings = this.bookings.where((b) {
        if (b.startDate.day == DateTime.now().day &&
            b.startDate.month == DateTime.now().month &&
            b.startDate.year == DateTime.now().year) return true;

        return false;
      }).toList();

      this._isLoading = false;
    });
  }

  Map<int, dynamic> getBookingMemoryImage(Booking booking) {
    Map<int, dynamic> imgs = {};
    for (int i = 0; i < booking.entities.length; i++) {
      dynamic img = booking.entities[i].images.length > 0
          ? Image.memory(base64Decode(booking.entities[i].images[0].img))
          : Icon(
              Icons.extension,
            );

      imgs[booking.entities[i].idEntity] = img;
    }
    return imgs;
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
                          return BookingListItemAdmin(bks[i],
                              getBookingMemoryImage(bks[i]), loadBookings);
                        }))
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.type == 'all'
                          ? Text(getCurrentLabelValue('lblNoBookings'))
                          : Text(getCurrentLabelValue('lblNoBookingsToday')),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: loadBookings,
                      )
                    ],
                  )));
  }
}
