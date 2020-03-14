import './image.dart';

class Company {
  final int id;
  final String name;
  final String description_RO;
  final String description_EN;
  final int idCategory;
  final String categoryName_RO;
  final String categoryName_EN;
  final int idSubcategory;
  final String subcategoryName_RO;
  final String subcategoryName_EN;
  final String email;
  final String phone;
  final int idCountry;
  final String countryName;
  final int idCounty;
  final int idCity;
  final String cityName;
  final String countyName;
  final String address;
  final double lat;
  final double lng;
  final List<Image> image;
  final DateTime dateCreated;
  final bool isEnabled;
  final bool allowOnlineBookings;

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
}
