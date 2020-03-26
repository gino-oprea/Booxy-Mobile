import 'dart:convert';

import '../models/booxy-image.dart';
import '../models/selected-entity-per-level.dart';
import '../helpers/dates-helper.dart';
import '../providers/booking-provider.dart';
import '../models/level-as-filter.dart';
import '../models/company.dart';
import '../models/booking-entity.dart';
import '../models/booking.dart';
import '../models/entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/booxy-image-provider.dart';

class CompanyBookingScreen extends StatefulWidget {
  static const String routeName = '/company-booking';

  @override
  _CompanyBookingScreenState createState() => _CompanyBookingScreenState();
}

class _CompanyBookingScreenState extends State<CompanyBookingScreen> {
  DateTime _pickedDate = DateTime.now();
  bool _isInit = true;
  Company _company;
  List<LevelAsFilter> _levels;
  List<LevelAsFilter> _filteredLevels;

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedBooking = Booking(
      entities: [],
      firstName: null,
      lastName: null,
      phone: null,
      email: null,
      startDate: null,
      startTime: null);

  List<Entity> _selectedEntities = [];

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this._company = ModalRoute.of(context).settings.arguments as Company;
      var weekDates = DatesHelper.getWeekDates(_pickedDate);

      BookingProvider()
          .getLevelsAsFilters(this._company.id, weekDates)
          .then((result) {
        setState(() {
          this._levels = result;
          this._filteredLevels = [];
          this._levels.forEach((l) {
            this._filteredLevels.add(new LevelAsFilter().clone(l));
          });
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save(); //triggers onSaved on every form field
    this._editedBooking.startDate = this._pickedDate;
  }

  List<DropdownMenuItem<Entity>> getDdlEntities(LevelAsFilter lvl) {
    List<DropdownMenuItem<Entity>> list = [];
    list.addAll(lvl.entities.map((ent) {
      return new DropdownMenuItem<Entity>(
        value: ent,
        child: new Text(ent.entityName_RO),
      );
    }).toList());

    return list;
  }

  Image getEntityImageForDdl(LevelAsFilter level) {
    var selectedEnt = _selectedEntities.firstWhere((e) => e.idLevel == level.id,
        orElse: () => null);
    if (selectedEnt != null) {
      if (selectedEnt.images != null)
        return Image.memory(base64Decode(selectedEnt.images[0].img));
    }
    return Image.network(
        'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png');
  }

  List<Widget> generateEntitiesDdls() {
    List<Widget> wdgs = [];

    if (_filteredLevels != null)
      _filteredLevels.forEach((level) {
        var ddl = Row(
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField<Entity>(
                isDense: true,
                decoration: InputDecoration(
                  labelText: level.levelName_RO,
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                ),
                value: _selectedEntities.firstWhere(
                    (e) => e.idLevel == level.id,
                    orElse: () => null),
                items: getDdlEntities(level),
                validator: (_) {
                  return _selectedEntities.firstWhere(
                              (e) => e.idLevel == level.id,
                              orElse: () => null) ==
                          null
                      ? 'camp obligatoriu'
                      : null;
                },
                onChanged: (Entity newValue) {
                  var selectedEnt = _selectedEntities.firstWhere(
                      (e) => e.idLevel == level.id,
                      orElse: () => null);
                  if (selectedEnt != null) {
                    _selectedEntities
                        .removeAt(_selectedEntities.indexOf(selectedEnt));
                  }

                  BooxyImageProvider().getEntityImage(newValue.id).then((img) {
                    setState(() {
                      if (img != null) newValue.images = [img];
                      _selectedEntities.add(newValue);
                    });
                  });
                },
                onSaved: (value) {
                  //this._editedBooking.entities.add(value);
                },
              ),
            ),
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(left: 10),
              child: FittedBox(
                child: getEntityImageForDdl(level),
                fit: BoxFit.cover,
              ),
            ),
          ],
        );

        wdgs.add(ddl);
      });

    return wdgs;
  }

  @override
  Widget build(BuildContext context) {
    var entitiesDdls = generateEntitiesDdls();

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
                  onSaved: (value) {
                    this._editedBooking.email = value;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ...entitiesDdls,
                SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: AlignmentDirectional.bottomStart,
                  child: RaisedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedEntities = [];
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Reset'),
                    elevation: 1,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  ),
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
