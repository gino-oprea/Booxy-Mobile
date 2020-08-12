import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import '../providers/companies-provider.dart';
import '../providers/login-provider.dart';
import '../models/booking.dart';
import '../models/generic-response-object.dart';
import '../models/auto-assign-payload.dart';
import '../models/auto-assigned-entity-combination.dart';
import '../models/timeslot.dart';
import '../models/level-as-filter.dart';
import '../config/booxy-config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingProvider with ChangeNotifier {
  Future<List<LevelAsFilter>> getLevelsAsFilters(
      int idCompany, List<String> weekDates) async {
    String url = BooxyConfig.api_endpoint +
        'Booking/GetBookingFilters/' +
        idCompany.toString();

    String httpParams = '';
    weekDates.forEach((date) {
      if (httpParams.isEmpty)
        httpParams = '?weekDates=' + date;
      else
        httpParams += '&weekDates=' + date;
    });

    url += httpParams;

    final response = await http.get(url);
    final List<LevelAsFilter> lvlsAsFilters = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return null;
    }

    final List<dynamic> objList = extractedData["objList"];

    if (objList.length == 0) return null;

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var lvl = new LevelAsFilter().fromJson(value);

      lvlsAsFilters.add(lvl);
    }

    return lvlsAsFilters;
  }

  Future<List<List<List<Timeslot>>>> generateHoursMatrix(int idCompany,
      List<String> weekDates, List<LevelAsFilter> selectedLevels) async {
    String url = BooxyConfig.api_endpoint +
        'Booking/GenerateHoursMatrix/' +
        idCompany.toString();

    String httpParams = '';
    weekDates.forEach((date) {
      if (httpParams.isEmpty)
        httpParams = '?weekDates=' + date;
      else
        httpParams += '&weekDates=' + date;
    });

    url += httpParams;

    var bdyObj = json.encode(selectedLevels.map((l) => l.toJson()).toList());

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: bdyObj);

    final List<List<List<Timeslot>>> timeslots = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    final List<dynamic> objList = extractedData["objList"];
    if (objList.length == 0) return null;

    for (int i = 0; i < objList.length; i++) {
      var days = objList[i] as List<dynamic>;
      List<List<Timeslot>> t_days = [];
      for (int j = 0; j < days.length; j++) {
        var hours = days[j] as List<dynamic>;
        List<Timeslot> t_hours = [];
        for (int k = 0; k < hours.length; k++) {
          var slot = hours[k];
          var timeslot = Timeslot().fromJson(slot);
          t_hours.add(timeslot);
        }
        t_days.add(t_hours);
      }
      timeslots.add(t_days);
    }
    return timeslots;
  }

  Future<GenericResponseObject> autoAssignEntitiesToBooking(
      int idCompany,
      String bookingDate,
      String startTime,
      AutoAssignPayload autoAssignPayload) async {
    String url = BooxyConfig.api_endpoint +
        'Booking/AutoAssignEntitiesToBooking/' +
        idCompany.toString() +
        '?bookingDate=' +
        bookingDate +
        '&startTime=' +
        startTime;

    var bdyObj = json.encode(autoAssignPayload.toJson());

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: bdyObj);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    gro.objList = new List<AutoAssignedEntityCombination>();

    if (gro.objListAsMap != null)
      for (int i = 0; i < gro.objListAsMap.length; i++) {
        var obj =
            new AutoAssignedEntityCombination().fromJson(gro.objListAsMap[i]);
        gro.objList.add(obj);
      }

    return gro;
  }

  Future<GenericResponseObject> addBooking(Booking booking) async {
    String url = BooxyConfig.api_endpoint + 'Booking?culture=RO';

    var bdyObj = json.encode(booking.toJson());

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: bdyObj);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    gro.objList = new List<AutoAssignedEntityCombination>();
    if (gro.objListAsMap != null)
      for (int i = 0; i < gro.objListAsMap.length; i++) {
        var obj =
            new AutoAssignedEntityCombination().fromJson(gro.objListAsMap[i]);
        gro.objList.add(obj);
      }

    return gro;
  }

  Future<GenericResponseObject> removePotentialBooking(
      int idPotentialBooking) async {
    String url = BooxyConfig.api_endpoint +
        'booking/RemovePotentialBooking/' +
        idPotentialBooking.toString();

    final response = await http.delete(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    final GenericResponseObject gro =
        GenericResponseObject().fromJson(extractedData);

    return gro;
  }

  Future<GenericResponseObject> cancelBooking(int idBooking,
      [bool withClientNotification = false]) async {
    String url = BooxyConfig.api_endpoint +
        'booking/CancelBooking/' +
        idBooking.toString() +
        '?withClientNotification=' +
        withClientNotification.toString() +
        '&culture=RO';

    var token = await LoginProvider().token;

    final response = await http.delete(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.access_token
    });

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) return null;

    final GenericResponseObject gro =
        GenericResponseObject().fromJson(extractedData);

    return gro;
  }

  Future<GenericResponseObject> getCurrentUserBookings() async {
    var currentUser = await LoginProvider().currentUser;
    var token = await LoginProvider().token;
    final url = BooxyConfig.api_endpoint +
        'booking/GetBookingsByUser/' +
        currentUser.id.toString() +
        '?date=' +
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: -1)));
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.access_token
    });
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    gro.objList = new List<Booking>();
    if (gro.objListAsMap != null)
      for (int i = 0; i < gro.objListAsMap.length; i++) {
        var obj = new Booking().fromJson(gro.objListAsMap[i]);
        if (!obj.startDate.isBefore(DateTime.now().add(Duration(days: -1)))) {
          obj.image =
              await CompaniesProvider(null).getCompanyImages(obj.idCompany);
          gro.objList.add(obj);
        }
      }

    return gro;
  }

  Future<GenericResponseObject> getCompanyBookings(int idCompany) async {
    var token = await LoginProvider().token;
    final url = BooxyConfig.api_endpoint +
        'booking/GetBookings/' +
        idCompany.toString() +
        '?dateStart=' +
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(Duration(days: -1))) +
        '&dateEnd=' +
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(Duration(days: 365 * 10))) +
        '&includeCanceled=true&filterByLinkedEntityToUser=true';

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.access_token
    });
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    gro.objList = new List<Booking>();
    if (gro.objListAsMap != null)
      for (int i = 0; i < gro.objListAsMap.length; i++) {
        var obj = new Booking().fromJson(gro.objListAsMap[i]);
        //if (!obj.startDate.isBefore(DateTime.now())) {
        obj.image =
            await CompaniesProvider(null).getCompanyImages(obj.idCompany);
        gro.objList.add(obj);
        //}
      }

    return gro;
  }

  Future<GenericResponseObject> setBookingStatus(
      Booking booking, int idStatus) async {
    String url = BooxyConfig.api_endpoint +
        'booking/SetBookingStatus/' +
        idStatus.toString();

    var token = await LoginProvider().token;

    var bdyObj = json.encode(booking.toJson());

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token.access_token
        },
        body: bdyObj);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    GenericResponseObject gro = GenericResponseObject().fromJson(extractedData);

    return gro;
  }
}
