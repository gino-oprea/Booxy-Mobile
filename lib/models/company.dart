import './image.dart';

class Company {
  int id;
  String name;
  String description_RO;
  String description_EN;
  int idCategory;
  String categoryName_RO;
  String categoryName_EN;
  int idSubcategory;
  String subcategoryName_RO;
  String subcategoryName_EN;
  String email;
  String phone;
  int idCountry;
  String countryName;
  int idCounty;
  int idCity;
  String cityName;
  String countyName;
  String address;
  double lat;
  double lng;
  List<BooxyImage> image;
  DateTime dateCreated;
  bool isEnabled;
  bool allowOnlineBookings;

  Company(
      {this.id,
      this.name,
      this.description_RO,
      this.description_EN,
      this.idCategory,
      this.categoryName_RO,
      this.categoryName_EN,
      this.idSubcategory,
      this.subcategoryName_RO,
      this.subcategoryName_EN,
      this.email,
      this.phone,
      this.idCountry,
      this.countryName,
      this.idCounty,
      this.idCity,
      this.cityName,
      this.countyName,
      this.address,
      this.lat,
      this.lng,
      this.image,
      this.dateCreated,
      this.isEnabled,
      this.allowOnlineBookings});

  Company fromJson(Map json) {
    this.id = json['id'];
    this.name = json['name'];
    this.description_RO = json['description_RO'];
    this.description_EN = json['description_EN'];
    this.idCategory = json['idCategory'];
    this.categoryName_RO = json['categoryName_RO'];
    this.categoryName_EN = json['categoryName_EN'];
    this.idSubcategory = json['idSubcategory'];
    this.subcategoryName_RO = json['subcategoryName_RO'];
    this.subcategoryName_EN = json['subcategoryName_EN'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.idCountry = json['idCountry'];
    this.countryName = json['countryName'];
    this.idCounty = json['idCounty'];
    this.idCity = json['idCity'];
    this.cityName = json['cityName'];
    this.countyName = json['countyName'];
    this.address = json['address'];
    this.lat = json['lat'];
    this.lng = json['lng'];
    this.image = null;
    this.dateCreated = null;
    this.isEnabled = json['isEnabled'];
    this.allowOnlineBookings = json['allowOnlineBookings'];

    return this;
  }
}
