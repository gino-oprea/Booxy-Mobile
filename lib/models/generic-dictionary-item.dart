class GenericDictionaryItem {
  int id;
  int idParent;
  String value_RO;
  String value_EN;

  GenericDictionaryItem({this.id, this.idParent, this.value_RO, this.value_EN});

  GenericDictionaryItem fromJson(json) {
    this.id = json['id'];
    this.idParent = json['idParent'];
    this.value_RO = json['value_RO'];
    this.value_EN = json['value_EN'];

    return this;
  }
}
