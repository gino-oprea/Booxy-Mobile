import 'dart:convert';
import 'dart:math';
import 'package:booxy/enums/actions-enum.dart';

import '../base-widgets/base-stateful-widget.dart';

import '../models/user.dart';

import '../providers/login-provider.dart';

import '../models/booking-entity.dart';
import '../models/generic-response-object.dart';

import '../providers/booking-provider.dart';

import '../models/auto-assigned-entity-combination.dart';
import '../models/booking-confirmation-payload.dart';
import '../models/company.dart';
import '../models/booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyBookingScreen extends BaseStatefulWidget {
  static const String routeName = '/company-booking';

  @override
  _CompanyBookingScreenState createState() => _CompanyBookingScreenState([
        'lblBooking',
        'lblMandatoryField',
        'lblFirstName',
        'lblLastName',
        'lblPhone',
        'lblSave',
        'lblDate',
        'lblPrice',
        'lblHour',
        'lblSaved'
      ]);
}

class _CompanyBookingScreenState extends BaseState<CompanyBookingScreen> {
  bool _isInit = true;
  Company _company;
  AutoAssignedEntityCombination _autoAssignedEntityCombination;
  DateTime _bookingDateTime;
  //User currentUser;

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

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

  _CompanyBookingScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Company booking confirm';
  }

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

      //for base logging
      this.idCompany = this._company.id;

      this._autoAssignedEntityCombination = (ModalRoute.of(context)
              .settings
              .arguments as BookingConfirmationPayload)
          .autoAssignedEntityCombination;
      this._bookingDateTime = (ModalRoute.of(context).settings.arguments
              as BookingConfirmationPayload)
          .bookingStartDate;

      // LoginProvider().currentUserProp.then((usr) {
      //   if (usr != null)
      //     setState(() {
      //       this.currentUser = usr;
      //       this._editedBooking.idUser = usr.id;
      //       this._firstNameController.text = usr.firstName;
      //       this._lastNameController.text = usr.lastName;
      //       this._emailController.text = usr.email;
      //       this._phoneController.text = usr.phone;
      //     });
      // });

    }

    super
        .didChangeDependencies(); //nu pot sa folosesc loginProvider decat dupa initializarea din baza

    if (_isInit) {
      setState(() {
        if (this.loginProvider.currentUser != null) {
          this._editedBooking.idUser = this.loginProvider.currentUser.id;
          this._firstNameController.text =
              this.loginProvider.currentUser.firstName;
          this._lastNameController.text =
              this.loginProvider.currentUser.lastName;
          this._emailController.text = this.loginProvider.currentUser.email;
          this._phoneController.text = this.loginProvider.currentUser.phone;
        }
      });
    }

    _isInit = false;
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

    this._editedBooking.bookingPrice =
        int.tryParse(this.getBookingPrice(withCurrencyString: false)) ?? null;
  }

  List<Widget> generateEntitiesTxts() {
    List<Widget> wdgs = [];

    if (this._autoAssignedEntityCombination != null &&
        this._autoAssignedEntityCombination.entityCombination != null)
      this._autoAssignedEntityCombination.entityCombination.forEach((entity) {
        var ddl = Column(
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

  String getBookingPrice({bool withCurrencyString = true}) {
    var ent = this
        ._autoAssignedEntityCombination
        .entityCombination
        .firstWhere((e) => e.defaultServicePrice != null, orElse: () => null);
    if (ent == null) return '';

    if (withCurrencyString)
      return ent.defaultServicePrice.toStringAsFixed(0) + ' RON';
    else
      return ent.defaultServicePrice.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    var entitiesTxts = generateEntitiesTxts();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(getCurrentLabelValue('lblBooking') + ' ' + this._company.name),
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
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText:
                                      getCurrentLabelValue('lblFirstName'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue(
                                          'lblMandatoryField')
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
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText:
                                      getCurrentLabelValue('lblLastName'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue(
                                          'lblMandatoryField')
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
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue('lblPhone'),
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
                                      ? getCurrentLabelValue(
                                          'lblMandatoryField')
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
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return 'Invalid Email';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ...entitiesTxts,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        // Text(
                                        //   getCurrentLabelValue('lblDate') + ': ',
                                        //   style: TextStyle(
                                        //       fontSize: 18,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.calendar_today,
                                          ),
                                          onPressed: () {},
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
                                    // Expanded(
                                    //   child: Container(
                                    //     alignment: AlignmentDirectional.centerEnd,
                                    //     child:
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Text(
                                    //   getCurrentLabelValue('lblPrice') + ': ',
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.monetization_on,
                                      ),
                                      onPressed: () {},
                                    ),
                                    Text(
                                      this.getBookingPrice(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        // Text(
                                        //   getCurrentLabelValue('lblHour') + ': ',
                                        //   style: TextStyle(
                                        //       fontSize: 18,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.timelapse,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Text(
                                          DateFormat('HH:mm').format(
                                                  this._bookingDateTime) +
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
              if (gro.error != '') {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(gro.error),
                    duration: Duration(seconds: 1),
                  ),
                );
                logAction(this.idCompany, true, ActionsEnum.Save, gro.error,
                    gro.errorDetailed);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(getCurrentLabelValue('lblSaved')),
                    duration: Duration(seconds: 1),
                  ),
                );
                logAction(this.idCompany, false, ActionsEnum.Save, '',
                    'Saved booking');
              }

              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).pop();
              });
            }
          },
          label: Text(getCurrentLabelValue('lblSave')),
          icon: Icon(Icons.check),
        ),
      ),
    );
  }
}
