import 'package:intl/intl.dart';

import './booking-entity.dart';

class Booking {
  int id;
  int idCompany;
  String companyName;
  String companyAddress;
  String companyEmail;
  String companyPhone;
  double lat;
  double lng;
  List<BookingEntity> entities;
  int idUser;
  String firstName;
  String lastName;
  String phone;
  String email;
  DateTime startDate;
  DateTime endDate;
  DateTime startTime;
  DateTime endTime;
  int bookingPrice;
  bool isPaidRetainer;
  bool isPaidFull;
  int clientRating;
  String clientReview;
  int idStatus;

  Booking(
      {this.id,
      this.idCompany,
      this.companyName,
      this.companyAddress,
      this.companyEmail,
      this.companyPhone,
      this.lat,
      this.lng,
      this.entities,
      this.idUser,
      this.firstName,
      this.lastName,
      this.phone,
      this.email,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.bookingPrice,
      this.isPaidRetainer,
      this.isPaidFull,
      this.clientRating,
      this.clientReview,
      this.idStatus});

  Booking fromJson(Map json) {
    this.id = json['id'];
    this.idCompany = json['idCompany'];
    this.companyName = json['companyName'];
    this.companyAddress = json['companyAddress'];
    this.companyEmail = json['companyEmail'];
    this.companyPhone = json['companyPhone'];
    this.lat = json['lat'];
    this.lng = json['lng'];
    this.entities = new List<BookingEntity>();
    List<dynamic> rawEntities = json['entities'];
    for (int i = 0; i < rawEntities.length; i++) {
      var entMap = rawEntities[i];
      var entity = new BookingEntity().fromJson(entMap);

      entities.add(entity);
    }
    this.idUser = json['idUser'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.phone = json['phone'];
    this.email = json['email'];
    this.startDate =
        json['startDate'] == null ? null : DateTime.parse(json['startDate']);
    this.endDate =
        json['endDate'] == null ? null : DateTime.parse(json['endDate']);
    this.startTime =
        json['startTime'] == null ? null : DateTime.parse(json['startTime']);
    this.endTime =
        json['endTime'] == null ? null : DateTime.parse(json['endTime']);
    this.bookingPrice = json['bookingPrice'];
    this.isPaidRetainer = json['isPaidRetainer'];
    this.isPaidFull = json['isPaidFull'];
    this.clientRating = json['clientRating'];
    this.clientReview = json['clientReview'];
    this.idStatus = json['idStatus'];

    return this;
  }

  Map toJson() {
    Map obj = {
      //'id': this.id,
      'idCompany': this.idCompany,
      // 'companyName': this.companyName,
      // 'companyAddress': this.companyAddress,
      // 'companyEmail': this.companyEmail,
      // 'companyPhone': this.companyPhone,
      // 'lat': this.lat,
      // 'lng': this.lng,
      'entities': this.entities != null
          ? this.entities.map((e) => e.toJson()).toList()
          : null,
      'idUser': this.idUser,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phone': this.phone,
      'email': this.email,
      'startDate': this.startDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm').format(this.startDate)
          : null,
      'endDate': this.endDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm').format(this.endDate)
          : null,
      'startTime': this.startTime != null
          ? DateFormat('yyyy-MM-ddTHH:mm').format(this.startTime)
          : null,
      'endTime': this.endTime != null
          ? DateFormat('yyyy-MM-ddTHH:mm').format(this.endTime)
          : null,
      // 'bookingPrice': this.bookingPrice,
      // 'isPaidRetainer': this.isPaidRetainer,
      // 'isPaidFull': this.isPaidFull,
      // 'clientRating': this.clientRating,
      // 'clientReview': this.clientReview,
      // 'idStatus': this.idStatus
    };
    return obj;
  }
}
