import 'dart:convert';
import '../models/booking-entity.dart';
import '../models/generic-response-object.dart';

import '../providers/booking-provider.dart';

import '../models/auto-assigned-entity-combination.dart';
import '../models/booking-confirmation-payload.dart';
import '../models/company.dart';
import '../models/booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyBookingScreen extends StatefulWidget {
  static const String routeName = '/company-booking';

  @override
  _CompanyBookingScreenState createState() => _CompanyBookingScreenState();
}

class _CompanyBookingScreenState extends State<CompanyBookingScreen> {
  bool _isInit = true;
  Company _company;
  AutoAssignedEntityCombination _autoAssignedEntityCombination;
  DateTime _bookingDateTime;

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedBooking = Booking(
      idUser: null,
      entities: [],
      firstName: null,
      lastName: null,
      phone: null,
      email: null,
      startDate: null,
      startTime: null,
      endTime: null);

  // List<Entity> _selectedEntities = [];

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();

    BookingProvider().removePotentialBooking(
        this._autoAssignedEntityCombination.idPotentialBooking);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this._company = (ModalRoute.of(context).settings.arguments
              as BookingConfirmationPayload)
          .company;
      this._autoAssignedEntityCombination = (ModalRoute.of(context)
              .settings
              .arguments as BookingConfirmationPayload)
          .autoAssignedEntityCombination;
      this._bookingDateTime = (ModalRoute.of(context).settings.arguments
              as BookingConfirmationPayload)
          .bookingStartDate;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<GenericResponseObject> saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return null;

    _form.currentState.save(); //triggers onSaved on every form field

    this.prepareBookingForSubmit();

    //submit
    return await BookingProvider().addBooking(this._editedBooking);
  }

  void prepareBookingForSubmit() {
    this._editedBooking.entities = [];
    this._autoAssignedEntityCombination.entityCombination.forEach((e) {
      this._editedBooking.entities.add(BookingEntity(
          idEntity: e.id,
          isAutoAssigned: false,
          entityName_RO: e.entityName_RO,
          entityName_EN: e.entityName_EN));
    });
    this._editedBooking.idCompany = this._company.id;
    this._editedBooking.startDate = this._bookingDateTime;
    this._editedBooking.startTime = this._bookingDateTime;
    this._editedBooking.endTime = this._bookingDateTime.add(
        Duration(milliseconds: this._autoAssignedEntityCombination.duration));
  }

  List<Widget> generateEntitiesTxts() {
    List<Widget> wdgs = [];

    if (this._autoAssignedEntityCombination != null &&
        this._autoAssignedEntityCombination.entityCombination != null)
      this._autoAssignedEntityCombination.entityCombination.forEach((entity) {
        var ddl = Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: entity.images.length > 0
                    ? Image.memory(base64Decode(entity.images[0].img))
                    : Icon(Icons.extension),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            // Expanded(
            // child:
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                entity.entityName_RO,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // ),
          ],
        );

        wdgs.add(ddl);
      });

    return wdgs;
  }

  String getBookingPrice() {
    var ent = this
        ._autoAssignedEntityCombination
        .entityCombination
        .firstWhere((e) => e.defaultServicePrice != null, orElse: () => null);
    if (ent == null) return '';

    return ent.defaultServicePrice.toStringAsFixed(0) + ' RON';
  }

  @override
  Widget build(BuildContext context) {
    var entitiesTxts = generateEntitiesTxts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Programare ' + this._company.name),
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.person,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _firstNameFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Prenume',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'camp obligatoriu'
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_lastNameFocusNode);
                                },
                                onSaved: (value) {
                                  this._editedBooking.firstName = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.person),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _lastNameFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Nume',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'camp obligatoriu'
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_phoneFocusNode);
                                },
                                onSaved: (value) {
                                  this._editedBooking.lastName = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.phone),
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _phoneFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Telefon',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'camp obligatoriu'
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocusNode);
                                },
                                onSaved: (value) {
                                  this._editedBooking.phone = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.email),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _emailFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onSaved: (value) {
                                  this._editedBooking.email = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        ...entitiesTxts,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Data: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      DateFormat('dd-MMM-yyyy')
                                          .format(this._bookingDateTime),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pret: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      this.getBookingPrice(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Ora: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      DateFormat('HH:mm')
                                              .format(this._bookingDateTime) +
                                          ' - ' +
                                          DateFormat('HH:mm').format(this
                                              ._bookingDateTime
                                              .add(Duration(
                                                  milliseconds: this
                                                      ._autoAssignedEntityCombination
                                                      .duration))),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () async {
            var gro = await saveForm();
            if (gro != null) {
              if (gro.error != '')
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(gro.error),
                    duration: Duration(seconds: 2),
                  ),
                );
              else
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Programare salvata'),
                    duration: Duration(seconds: 2),
                  ),
                );

              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
            }
          },
          label: Text('Salveaza'),
          icon: Icon(Icons.check),
        ),
      ),
    );
  }
}
