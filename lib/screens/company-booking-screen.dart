import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyBookingScreen extends StatefulWidget {
  static const String routeName = '/company-booking';

  @override
  _CompanyBookingScreenState createState() => _CompanyBookingScreenState();
}

class _CompanyBookingScreenState extends State<CompanyBookingScreen> {
  DateTime _pickedDate = DateTime.now();

  final _dateTextEditingController = TextEditingController();

  @override
  void initState() {
    _dateTextEditingController.text =
        DateFormat('dd-MMM-yyyy').format(_pickedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Programare'),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Entitate 1',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return value.isEmpty ? 'camp obligatoriu' : null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Entitate 2',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return value.isEmpty ? 'camp obligatoriu' : null;
                  },
                ),
                TextFormField(
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
                ),
                TextFormField(
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
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Telefon',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return value.isEmpty ? 'camp obligatoriu' : null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pret',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _dateTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Data',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return value.isEmpty ? 'camp obligatoriu' : null;
                        },
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
                                _dateTextEditingController.text =
                                    DateFormat('dd-MMM-yyyy')
                                        .format(_pickedDate);
                              });
                          });
                        },
                      ),
                    )
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ora inceput',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return value.isEmpty ? 'camp obligatoriu' : null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ora sfarsit',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Salveaza programarea'),
        icon: Icon(Icons.check),
      ),
    );
  }
}
