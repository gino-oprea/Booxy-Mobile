class County {
  int id;
  String name;
  String code;
  int idCountry;

  County({this.id, this.name, this.code, this.idCountry});

  County fromJson(Map json) {
    this.id = json['id'];
    this.name = json['name'];
    this.code = json['code'];
    this.idCountry = json['idCountry'];

    return this;
  }
}
