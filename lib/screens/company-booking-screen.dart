import 'dart:convert';

import '../models/booking-entity.dart';

import '../models/booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyBookingScreen extends StatefulWidget {
  static const String routeName = '/company-booking';

  @override
  _CompanyBookingScreenState createState() => _CompanyBookingScreenState();
}

class _CompanyBookingScreenState extends State<CompanyBookingScreen> {
  DateTime _pickedDate = DateTime.now();

  final _ent2FocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _startTimeFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedBooking = Booking(
      entities: [],
      firstName: null,
      lastName: null,
      phone: null,
      email: null,
      startDate: null,
      startTime: null);

  List<BookingEntity> _entities1 = [];
  List<BookingEntity> _entities2 = [];

  BookingEntity _selectedEntity1;
  BookingEntity _selectedEntity2;

  @override
  void initState() {
    this._entities1 = [
      BookingEntity(
        idEntity: 1,
        entityName_RO: 'ent 1',
      ),
      BookingEntity(
        idEntity: 2,
        entityName_RO: 'ent 2',
      ),
      BookingEntity(
        idEntity: 3,
        entityName_RO: 'ent 3',
      ),
      BookingEntity(
        idEntity: 4,
        entityName_RO: 'ent 4',
      ),
      BookingEntity(
        idEntity: 5,
        entityName_RO: 'ent 5',
      ),
    ];
    this._entities2 = [
      BookingEntity(
        idEntity: 6,
        entityName_RO: 'ent 6',
      ),
      BookingEntity(
        idEntity: 7,
        entityName_RO: 'ent 7',
      ),
      BookingEntity(
        idEntity: 8,
        entityName_RO: 'ent 8',
      ),
      BookingEntity(
        idEntity: 9,
        entityName_RO: 'ent 9',
      ),
      BookingEntity(
        idEntity: 10,
        entityName_RO: 'ent 10',
      ),
    ];

    super.initState();
  }

  void saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save(); //triggers onSaved on every form field
    this._editedBooking.startDate = this._pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programare'),
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<BookingEntity>(
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'Nivel 1',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                        ),
                        validator: (value) {
                          return value == null ? 'camp obligatoriu' : null;
                        },
                        value: _selectedEntity1,
                        items: _entities1.map((ent) {
                          return new DropdownMenuItem<BookingEntity>(
                            value: ent,
                            child: new Text(ent.entityName_RO),
                          );
                        }).toList(),
                        onChanged: (BookingEntity newValue) {
                          setState(() {
                            _selectedEntity1 = newValue;
                          });
                        },
                        onSaved: (value) {
                          this._editedBooking.entities.add(value);
                        },
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(left: 10),
                      child: FittedBox(
                        child: Image.network(
                            'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<BookingEntity>(
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'Nivel 2',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                        ),
                        validator: (value) {
                          return value == null ? 'camp obligatoriu' : null;
                        },
                        value: _selectedEntity2,
                        items: _entities2.map((ent) {
                          return new DropdownMenuItem<BookingEntity>(
                            value: ent,
                            child: new Text(ent.entityName_RO),
                          );
                        }).toList(),
                        onChanged: (BookingEntity newValue) {
                          setState(() {
                            _selectedEntity2 = newValue;
                          });
                        },
                        onSaved: (value) {
                          this._editedBooking.entities.add(value);
                        },
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(left: 10),
                      child: FittedBox(
                        child: Image.network(
                            'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  focusNode: _firstNameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Prenume',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return value.isEmpty ? 'camp obligatoriu' : null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_lastNameFocusNode);
                  },
                  onSaved: (value) {
                    this._editedBooking.firstName = value;
                  },
                ),
                TextFormField(
                  focusNode: _lastNameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Nume',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return value.isEmpty ? 'camp obligatoriu' : null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_phoneFocusNode);
                  },
                  onSaved: (value) {
                    this._editedBooking.lastName = value;
                  },
                ),
                TextFormField(
                  focusNode: _phoneFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Telefon',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return value.isEmpty ? 'camp obligatoriu' : null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                  onSaved: (value) {
                    this._editedBooking.phone = value;
                  },
                ),
                TextFormField(
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_startTimeFocusNode);
                  },
                  onSaved: (value) {
                    this._editedBooking.email = value;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.lightGreenAccent,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Pret: 100 RON',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Data: ' +
                            DateFormat('dd-MMM-yyyy').format(_pickedDate),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day),
                                  lastDate: DateTime(2100))
                              .then((selectedDate) {
                            if (selectedDate == null)
                              return;
                            else
                              setState(() {
                                _pickedDate = selectedDate;
                              });
                          });
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        focusNode: _startTimeFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Ora inceput',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          return value.isEmpty ? 'camp obligatoriu' : null;
                        },
                        onFieldSubmitted: (_) {
                          saveForm();
                        },
                      ),
                    ),
                    Expanded(child: Text('Ora sfarsit: ...')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveForm,
        label: Text('Salveaza'),
        icon: Icon(Icons.check),
      ),
    );
  }
}
