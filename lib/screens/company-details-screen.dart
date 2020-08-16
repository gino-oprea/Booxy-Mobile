import 'dart:convert';
import '../models/auto-assign-payload.dart';
import '../base-widgets/base-stateful-widget.dart';
import '../models/booking-confirmation-payload.dart';
import '../providers/booxy-image-provider.dart';
import 'package:intl/intl.dart';
import './company-booking-screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/company.dart';
import 'package:flutter/material.dart';
import '../models/timeslot.dart';
import '../models/entities-link.dart';
import '../helpers/dates-helper.dart';
import '../providers/booking-provider.dart';
import '../models/level-as-filter.dart';
import '../models/entity.dart';
import '../providers/level-linking-provider.dart';

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
  DateTime _pickedDate = DateTime.now().add(Duration(days: 1));
  bool _isInit = true;
  Company _company;
  List<LevelAsFilter> _levels;
  List<LevelAsFilter> _filteredLevels;
  List<LevelAsFilter> _filteredLevelsForApiCall;
  List<List<Entity>> allEntityCombinations = [];
  List<List<List<Timeslot>>> _timeslotMatrix = [];
  List<Timeslot> _timeslots = [];
  Timeslot _selectedTimeslot;
  List<Entity> _selectedEntities = [];

  LatLng defaultLatLng = LatLng(45.9442858, 25.0094303);

  final _form = GlobalKey<FormState>();

  _CompanyDetailsScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Company details';
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this._company = ModalRoute.of(context).settings.arguments as Company;

      //for base logging
      this.idCompany = this._company.id;

      var weekDates = DatesHelper.getWeekDates(_pickedDate);

      Future.wait([
        BookingProvider().getLevelsAsFilters(this._company.id, weekDates),
        LevelLinkingProvider().getEntitiesLinking(null, this._company.id)
      ]).then((results) {
        this._levels = results[0];

        addChildEntityIdsToParentEntities(results[1]);
        List<Entity> firstLevelEntities =
            this._levels.firstWhere((l) => l.orderIndex == 1).entities;
        List<Entity> currentCombination = [];
        this.getAllLinkedEntitiesCombinations(
            firstLevelEntities, currentCombination, this.allEntityCombinations);

        this.initFilteredLevels();
        this.initFilteredLevelsForApiCall();
        this.initTimeslots();
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void initTimeslots() {
    BookingProvider()
        .generateHoursMatrix(this._company.id,
            DatesHelper.getWeekDates(_pickedDate), _filteredLevelsForApiCall)
        .then((timeslotsMatrix) {
      this._timeslotMatrix = timeslotsMatrix;
      var flatTimeslots = flattenTimeslotMatrix(timeslotsMatrix);
      setState(() {
        _timeslots = flatTimeslots.where((t) {
          return DateFormat('yyyy-MM-dd').format(t.startTime) ==
                  DateFormat('yyyy-MM-dd').format(_pickedDate) &&
              t.isSelectable &&
              !t.isFullBooked;
        }).toList();
      });
    });
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

  Widget getEntityImageForDdl(LevelAsFilter level) {
    Widget imageWidget;
    var selectedEnt = _selectedEntities.firstWhere((e) => e.idLevel == level.id,
        orElse: () => null);
    if (selectedEnt != null) {
      if (selectedEnt.images != null) {
        imageWidget = Image.memory(base64Decode(selectedEnt.images[0].img));
        return Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(5),
          child: FittedBox(
            child: imageWidget,
            fit: BoxFit.cover,
          ),
        );
      }
    }
    // return Image.network(
    //     'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png');
    imageWidget = Icon(Icons.extension);
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(5),
      child: FittedBox(
        child: imageWidget,
        fit: BoxFit.cover,
      ),
    );
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

      _selectedTimeslot = null;
      BookingProvider()
          .generateHoursMatrix(this._company.id,
              DatesHelper.getWeekDates(_pickedDate), _filteredLevelsForApiCall)
          .then((timeslotsMatrix) {
        setState(() {
          this._timeslotMatrix = timeslotsMatrix;
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
            getEntityImageForDdl(level),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: DropdownButtonFormField<Entity>(
                    isDense: true,
                    decoration: InputDecoration(
                      labelText: cultureProvider.getCurrentCulture() == 'EN'
                          ? level.levelName_EN
                          : level.levelName_RO,
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor)),
                    ),
                    value: _selectedEntities.firstWhere(
                        (e) => e.idLevel == level.id,
                        orElse: () => null),
                    items: getDdlEntities(level),
                    onChanged: (Entity newValue) {
                      onEntityChange(newValue, level);
                    }),
              ),
            ),
          ],
        );

        wdgs.add(ddl);
      });

    return wdgs;
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
        this._selectedTimeslot = null;
        this.initTimeslots();
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

    var entitiesDdls = generateEntitiesDdls();

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
                          Text(
                            getCurrentLabelValue('lblAddress') +
                                ': ' +
                                _company.address,
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            getCurrentLabelValue('lblPhone') +
                                ': ' +
                                _company.phone,
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Email: ' + _company.email,
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
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
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      ...entitiesDdls,
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Center(
                            child: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                        lastDate: DateTime(2100))
                                    .then((selectedDate) {
                                  if (selectedDate == null)
                                    return;
                                  else
                                    _pickedDate = selectedDate;

                                  _selectedTimeslot = null;

                                  var filteredEntititesPerLevel =
                                      this.getFilteredEntitiesPerLevel();
                                  this.setupFilterObjectForApiCall(
                                      filteredEntititesPerLevel);
                                  this.initTimeslots();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                getCurrentLabelValue('lblDate') +
                                    ': ' +
                                    DateFormat('dd-MMM-yyyy')
                                        .format(_pickedDate),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            alignment: AlignmentDirectional.bottomStart,
                            child: RaisedButton.icon(
                              onPressed: () {
                                _selectedEntities = [];
                                _selectedTimeslot = null;
                                this.initFilteredLevels();
                                this.initFilteredLevelsForApiCall();
                                this.initTimeslots();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(18.0)),
                              icon: Icon(Icons.refresh),
                              label: Text('Reset'),
                              elevation: 1,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: Theme.of(context).accentColor,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Form(
                        key: _form,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.access_time),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<Timeslot>(
                                  isDense: true,
                                  decoration: InputDecoration(
                                    labelText:
                                        getCurrentLabelValue('lblStartTime'),
                                    contentPadding: EdgeInsets.all(0),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor)),
                                  ),
                                  value: _selectedTimeslot,
                                  items: _timeslots.map((timeslot) {
                                    return new DropdownMenuItem<Timeslot>(
                                      child: Text(DateFormat('HH:mm')
                                          .format(timeslot.startTime)),
                                      value: timeslot,
                                    );
                                  }).toList(),
                                  validator: (_) {
                                    return _selectedTimeslot == null
                                        ? getCurrentLabelValue(
                                            'lblMandatoryField')
                                        : null;
                                  },
                                  onChanged: (Timeslot newValue) {
                                    setState(() {
                                      _selectedTimeslot = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Row(
            //   children: <Widget>[
            //     Container(
            //       width: 150,
            //       padding: const EdgeInsets.all(10),
            //       child: Text(
            //         'Ore de program: ',
            //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: FutureBuilder<WorkingHours>(
            //         future: WorkingHoursProvider()
            //             .getCompanyWorkingHours(company.id),
            //         builder: (context, snapshot) {
            //           if (snapshot.connectionState == ConnectionState.waiting) {
            //             return Center(child: CircularProgressIndicator());
            //           } else {
            //             if (snapshot.error != null) {
            //               // ...
            //               // Do error handling stuff
            //               return Center(
            //                 child: Text('An error occurred!'),
            //               );
            //             } else {
            //               return _generateScheduleWidgets(snapshot.data);
            //             }
            //           }
            //         },
            //       ),
            //     ),
            //   ],
            // ),
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
