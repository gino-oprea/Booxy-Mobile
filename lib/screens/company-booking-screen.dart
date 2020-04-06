import 'dart:convert';
import '../models/timeslot.dart';

import '../models/entities-link.dart';

import '../helpers/dates-helper.dart';
import '../providers/booking-provider.dart';
import '../models/level-as-filter.dart';
import '../models/company.dart';

import '../models/booking.dart';
import '../models/entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/booxy-image-provider.dart';
import '../providers/level-linking-provider.dart';

class CompanyBookingScreen extends StatefulWidget {
  static const String routeName = '/company-booking';

  @override
  _CompanyBookingScreenState createState() => _CompanyBookingScreenState();
}

class _CompanyBookingScreenState extends State<CompanyBookingScreen> {
  DateTime _pickedDate = DateTime.now().add(Duration(days: 1));
  bool _isInit = true;
  Company _company;
  List<LevelAsFilter> _levels;
  List<LevelAsFilter> _filteredLevels;
  List<LevelAsFilter> _filteredLevelsForApiCall;
  List<List<Entity>> allEntityCombinations = [];
  List<Timeslot> _timeslots = [];
  Timeslot _selectedTimeslot = null;

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

      Future.wait([
        BookingProvider().getLevelsAsFilters(this._company.id, weekDates),
        LevelLinkingProvider().getEntitiesLinking(null, this._company.id)
      ]).then((results) {
        setState(() {
          this._levels = results[0];

          addChildEntityIdsToParentEntities(results[1]);
          List<Entity> firstLevelEntities =
              this._levels.firstWhere((l) => l.orderIndex == 1).entities;
          List<Entity> currentCombination = [];
          this.getAllLinkedEntitiesCombinations(firstLevelEntities,
              currentCombination, this.allEntityCombinations);

          this.initFilteredLevels();
          this.initFilteredLevelsForApiCall();
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void initFilteredLevels() {
    this._filteredLevels = [];
    this._levels.forEach((l) {
      this._filteredLevels.add(new LevelAsFilter().clone(l));
    });
  }

  void initFilteredLevelsForApiCall() {
    this._filteredLevelsForApiCall = [];
    this._levels.forEach((l) {
      this._filteredLevelsForApiCall.add(new LevelAsFilter().clone(l));
    });
  }

  void setupFilterObjectForApiCall(
      List<List<Entity>> filteredEntititesPerLevel) {
    //le punem in obiectul care trebuie emis
    for (int i = 0; i < filteredEntititesPerLevel.length; i++) {
      var filteredEntities = filteredEntititesPerLevel[i];
      for (int j = 0; j < this._filteredLevelsForApiCall.length; j++) {
        var filteredLevel = this._filteredLevelsForApiCall[j];
        if (filteredEntities.length > 0) if (filteredLevel.id ==
            filteredEntities[0].idLevel)
          filteredLevel.entities = filteredEntities;
      }
    }
    ////
  }

  void setupFilterObjectForDropdowns(
      List<List<Entity>> filteredEntititesPerLevel, int idLevel) {
    //le punem in obiectul legat la interfata -- diferenta e ca aici nu filtram dropdown-ul care a declansat filtrarea si trebuie reinitializate valorile ca sa nu fie afectate de filtrari repetate
    this.initFilteredLevels();
    for (int i = 0; i < filteredEntititesPerLevel.length; i++) {
      var filteredEntities = filteredEntititesPerLevel[i];
      for (var j = 0; j < this._filteredLevels.length; j++) {
        var filteredLevelForDropdowns = this._filteredLevels[j];
        if (filteredEntities.length > 0) if (filteredLevelForDropdowns.id ==
                filteredEntities[0].idLevel &&
            filteredLevelForDropdowns.id != idLevel)
          filteredLevelForDropdowns.entities = filteredEntities;
      }
    }
    ///////
  }

  void addChildEntityIdsToParentEntities(List<EntitiesLink> entityLinks) {
    this._levels.forEach((l) {
      l.entities.forEach((e) {
        entityLinks.forEach((el) {
          if (e.childEntityIds == null) e.childEntityIds = [];
          if (e.id == el.idParentEntity) e.childEntityIds.add(el.idChildEntity);
        });
      });
    });
  }

  void getAllLinkedEntitiesCombinations(List<Entity> currentEntities,
      List<Entity> currentCombination, List<List<Entity>> resultCombinations) {
    for (var i = 0; i < currentEntities.length; i++) {
      var currentEntity = currentEntities[i];
      currentCombination.add(currentEntity);

      if (currentEntity.childEntityIds != null &&
          currentEntity.childEntityIds.length > 0) {
        var childEntities = this.getEntitiesByIds(currentEntity.childEntityIds);
        this.getAllLinkedEntitiesCombinations(
            childEntities, currentCombination, resultCombinations);
      } else {
        ////copy id list
        List<Entity> tempEntList = [];
        currentCombination.forEach((e) {
          tempEntList.add(e);
        });
        resultCombinations.add(tempEntList);
      }
      currentCombination.removeAt(currentCombination.length -
          1); //backtracking cu un pas mai sus pe combinatia gasita ca sa sare pe copilul urmator
    }
  }

  List<Entity> getEntitiesByIds(List<int> entityIds) {
    List<Entity> resultEntities = [];
    entityIds.forEach((ei) {
      this._levels.forEach((l) {
        l.entities.forEach((e) {
          if (ei == e.id) resultEntities.add(e);
        });
      });
    });
    return resultEntities;
  }

  List<List<Entity>> getFilteredEntitiesPerLevel() {
    List<List<Entity>> filteredEntitiesPerLevel = [];

    //filtram path-urile dupa selected entities(trebuie pastrate doar cele care contin toate entitatile selectate)
    List<List<Entity>> filteredCombinations = [];
    for (var i = 0; i < this.allEntityCombinations.length; i++) {
      if (this.isValidCombination(this.allEntityCombinations[i]))
        filteredCombinations.add(this.allEntityCombinations[i]);
    }
    /////

    ////grupare per nivel
    if (filteredCombinations.length > 0) {
      int levelsNumber = this.getMaxDepth(filteredCombinations);

      for (var i = 0; i < levelsNumber; i++) {
        List<Entity> levelEntitites = [];
        filteredCombinations.forEach((combination) {
          if (combination.length > i) {
            var exists = levelEntitites.where((e) => e.id == combination[i].id);
            if (exists.length == 0) //nu mai exista
              levelEntitites.add(combination[i]);
          }
        });
        filteredEntitiesPerLevel.add(levelEntitites);
      }
    }
    return filteredEntitiesPerLevel;
  }

  bool isValidCombination(
      List<Entity>
          combination) //filtreaza combinatiile pe baza selectiei utilizatorului
  {
    var containsAll = true;

    for (var i = 0; i < this._selectedEntities.length; i++) {
      var isFound = false;
      var selectedEntity = this._selectedEntities[i];
      for (var j = 0; j < combination.length; j++) {
        if (selectedEntity.id == combination[j].id) {
          isFound = true;
          break;
        }
      }

      if (!isFound) {
        containsAll = false;
        break;
      }
    }

    return containsAll;
  }

  int getMaxDepth(List<List<Entity>> combinations) {
    if (combinations.length > 0) {
      var max = combinations[0].length;
      for (var i = 0; i < combinations.length; i++) {
        if (combinations[0].length > max) max = combinations[0].length;
      }
      return max;
    } else
      return 0;
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

  void resetInvalidSelections(int idSelectedLevel) {
    var foundValidCombination = false;
    for (var i = 0; i < this.allEntityCombinations.length; i++) {
      if (this.isValidCombination(this.allEntityCombinations[i])) {
        foundValidCombination = true;
        break;
      }
    }
    if (!foundValidCombination) {
      this._selectedEntities.removeWhere((e) => e.idLevel != idSelectedLevel);
    }
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

  void onEntityChange(Entity newValue, LevelAsFilter level) {
    var selectedEnt = _selectedEntities.firstWhere((e) => e.idLevel == level.id,
        orElse: () => null);
    if (selectedEnt != null) {
      _selectedEntities.removeAt(_selectedEntities.indexOf(selectedEnt));
    }

    BooxyImageProvider().getEntityImage(newValue.id).then((img) {
      // setState(() {
      if (img != null) newValue.images = [img];
      _selectedEntities.add(newValue);

      this.resetInvalidSelections(level.id);
      var filteredEntititesPerLevel = this.getFilteredEntitiesPerLevel();
      this.setupFilterObjectForApiCall(filteredEntititesPerLevel);
      this.setupFilterObjectForDropdowns(filteredEntititesPerLevel, level.id);

      BookingProvider()
          .generateHoursMatrix(this._company.id,
              DatesHelper.getWeekDates(_pickedDate), _filteredLevelsForApiCall)
          .then((timeslotsMatrix) {
        setState(() {
          var flatTimeslots = flattenTimeslotMatrix(timeslotsMatrix);
          _timeslots = flatTimeslots.where((t) {
            return DateFormat('yyyy-MM-dd').format(t.startTime) ==
                    DateFormat('yyyy-MM-dd').format(_pickedDate) &&
                t.isSelectable &&
                !t.isFullBooked;
          }).toList();
        });
      });
      // });
    });
  }

  List<Timeslot> flattenTimeslotMatrix(List<List<List<Timeslot>>> matrix) {
    List<Timeslot> timeslots = [];

    for (var i = 0; i < matrix.length; i++) {
      var l1 = matrix[i];
      for (var j = 0; j < l1.length; j++) {
        var l2 = l1[j];
        for (var k = 0; k < l2.length; k++) {
          var l3 = l2[k];
          timeslots.add(l3);
        }
      }
    }

    return timeslots;
  }

  List<Widget> generateEntitiesDdls() {
    List<Widget> wdgs = [];

    if (_filteredLevels != null)
      _filteredLevels.forEach((level) {
        var ddl = Row(
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
            ),
            Expanded(
              child: DropdownButtonFormField<Entity>(
                isDense: true,
                decoration: InputDecoration(
                  labelText: level.levelName_RO,
                  contentPadding: EdgeInsets.all(0),
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
                  onEntityChange(newValue, level);
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
                          return value.isEmpty ? 'camp obligatoriu' : null;
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
                          return value.isEmpty ? 'camp obligatoriu' : null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phoneFocusNode);
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
                          return value.isEmpty ? 'camp obligatoriu' : null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
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
                SizedBox(
                  height: 10,
                ),
                ...entitiesDdls,
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      alignment: AlignmentDirectional.bottomStart,
                      child: RaisedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedEntities = [];
                            this.initFilteredLevels();
                            this.initFilteredLevelsForApiCall();
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
                      width: 15,
                    ),
                    Expanded(
                      child: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          'Pret: 100 RON',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Data: ' +
                              DateFormat('dd-MMM-yyyy').format(_pickedDate),
                          style: TextStyle(fontSize: 18),
                        ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<Timeslot>(
                          isDense: true,
                          decoration: InputDecoration(
                            labelText: 'Ora inceput',
                            contentPadding: EdgeInsets.all(0),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                          ),
                          value: _selectedTimeslot,
                          items: _timeslots.map((timeslot) {
                            return new DropdownMenuItem<Timeslot>(
                              child: Text(DateFormat('hh:mm')
                                  .format(timeslot.startTime)),
                              value: timeslot,
                            );
                          }).toList(),
                          validator: (_) {
                            return _selectedTimeslot == null
                                ? 'camp obligatoriu'
                                : null;
                          },
                          onChanged: (Timeslot newValue) {},
                          onSaved: (value) {},
                        ),
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
