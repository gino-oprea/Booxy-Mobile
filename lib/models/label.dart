class Label {
  String labelName;
  String ro;
  String en;
  String error;
  String errorDetailed;

  Label({this.labelName, this.ro, this.en, this.error, this.errorDetailed});

  Label fromJson(Map json) {
    this.labelName = json['labelName'];
    this.ro = json['ro'];
    this.en = json['en'];
    this.error = json['error'];
    this.errorDetailed = json['errorDetailed'];

    return this;
  }
}
