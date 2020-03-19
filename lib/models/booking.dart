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
}
