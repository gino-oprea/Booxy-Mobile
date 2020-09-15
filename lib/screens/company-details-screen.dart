import 'dart:convert';
import 'package:booxy/widgets/booking-filter.dart';

import '../models/auto-assign-payload.dart';
import '../base-widgets/base-stateful-widget.dart';
import '../models/booking-confirmation-payload.dart';
import 'package:intl/intl.dart';
import './company-booking-screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/company.dart';
import 'package:flutter/material.dart';
import '../models/timeslot.dart';
import '../providers/booking-provider.dart';
import '../models/level-as-filter.dart';

class CompanyDetailsScreen extends BaseStatefulWidget {
  static const routeName = '/company-details';

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState([
        'lblDate',
        'lblStartTime',
        'lblBookNow',
        'lblPhone',
        'lblAddress',
        'lblMandatoryField',
        'lblTimeslotNotFit'
      ]);
}

class _CompanyDetailsScreenState extends BaseState<CompanyDetailsScreen> {
  DateTime _pickedDate; // = DateTime.now().add(Duration(days: 1));
  bool _isInit = true;
  Company _company;
  // List<LevelAsFilter> _levels;
  // List<LevelAsFilter> _filteredLevels;
  List<LevelAsFilter> _filteredLevelsForApiCall;
  // List<List<Entity>> allEntityCombinations = [];
  List<List<List<Timeslot>>> _timeslotMatrix = [];
  // List<Timeslot> _timeslots = [];
  Timeslot _selectedTimeslot;
  // List<Entity> _selectedEntities = [];
  //bool resetSelectedTimeslot = false;

  LatLng defaultLatLng = LatLng(45.9442858, 25.0094303);

  final _form = GlobalKey<FormState>();
  final GlobalKey<BookingFilterState> _bookingFilterState =
      GlobalKey<BookingFilterState>();

  _CompanyDetailsScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Company details';
  }

  setupBookingFilterSelection(
      List<LevelAsFilter> fltLevels,
      List<List<List<Timeslot>>> tsMatrix,
      DateTime pkDate,
      Timeslot slTimeslot) {
    this._filteredLevelsForApiCall = fltLevels;
    this._timeslotMatrix = tsMatrix;
    this._pickedDate = pkDate;
    this._selectedTimeslot = slTimeslot;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this._company = ModalRoute.of(context).settings.arguments as Company;

      //for base logging
      this.idCompany = this._company.id;      
    }
    _isInit = false;

    super.didChangeDependencies();
  }  

  Future<String> bookNow() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return '';

    var autoAssignPayload = AutoAssignPayload(
        selectedLevels: this._filteredLevelsForApiCall,
        bookingDayTimeslots: this._timeslotMatrix.firstWhere((t) =>
            DateFormat('yyyy-MM-dd').format(t[0][0].startTime) ==
            DateFormat('yyyy-MM-dd').format(_pickedDate)));

    var gro = await BookingProvider().autoAssignEntitiesToBooking(
        this._company.id,
        DateFormat('yyyy-MM-dd').format(this._pickedDate),
        DateFormat('HH:mm').format(this._selectedTimeslot.startTime),
        autoAssignPayload);

    if (gro.objList.length > 0) {
      var obj = gro.objList[
          0]; //AutoAssignedEntityCombination().fromJson(gro.objList[0]);
      Navigator.of(context)
          .pushNamed(CompanyBookingScreen.routeName,
              arguments: BookingConfirmationPayload(
                  company: this._company,
                  autoAssignedEntityCombination: obj,
                  bookingStartDate: this._selectedTimeslot.startTime))
          .then((_) {
        this._bookingFilterState.currentState.resetTimeslots();
      });

      return '';
    } else
      return 'not_available';
  }  

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        _company.name,
        textAlign: TextAlign.center,
      ),
    );

    var companyGoogleMap = GoogleMap(
      initialCameraPosition: CameraPosition(target: defaultLatLng, zoom: 5),
      mapType: MapType.normal,
    );

    if (_company.lat != null)
      companyGoogleMap = GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(_company.lat, _company.lng), zoom: 16),
        mapType: MapType.normal,
        markers: {
          Marker(
              markerId: MarkerId('m1'),
              position: LatLng(_company.lat, _company.lng)),
        },
      );
    Widget bookingFilter = BookingFilter(this._bookingFilterState,
        this._company, this._form, this.setupBookingFilterSelection);

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
              child: Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 120,
                      width: 120,
                      child: _company.image.length > 0
                          ? Image.memory(
                              base64Decode(_company.image[0].img),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.network(
                              'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.my_location,
                                ),
                                onPressed: () {},
                              ),
                              Flexible(
                                child: Text(
                                  _company.address,
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.phone,
                                ),
                                onPressed: () {},
                              ),
                              Flexible(
                                child: Text(
                                  _company.phone,
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.email,
                                ),
                                onPressed: () {},
                              ),
                              Flexible(
                                child: Text(
                                  _company.email,
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Card(
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: companyGoogleMap,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: bookingFilter,              
            ),            
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () async {
            String res = await this.bookNow();
            if (res == 'not_available') {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(getCurrentLabelValue('lblTimeslotNotFit')),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          label: Text(getCurrentLabelValue('lblBookNow')),
          icon: Icon(Icons.thumb_up),
        ),
      ),
    );
  }
}
