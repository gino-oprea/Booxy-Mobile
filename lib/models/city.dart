class City {
  int id;
  int idCounty;
  String siruta;
  double longitude;
  double latitude;
  String name;
  String region;

  City(
      {this.id,
      this.idCounty,
      this.siruta,
      this.longitude,
      this.latitude,
      this.name,
      this.region});

  City fromJson(Map json) {
    this.id = json['id'];
    this.idCounty = json['idCounty'];
    this.siruta = json['siruta'];
    this.longitude = json['longitude'];
    this.latitude = json['latitude'];
    this.name = json['name'];
    this.region = json['region'];

    return this;
  }
}
