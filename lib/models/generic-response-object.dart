class GenericResponseObject {
  List<dynamic> objListAsMap;
  List<dynamic> objList;
  String info;
  String error;
  String errorDetailed;

  GenericResponseObject(
      {this.objList, this.info, this.error, this.errorDetailed});

  GenericResponseObject fromJson(Map json) {
    this.objListAsMap = json['objList'];
    this.info = json['info'];
    this.error = json['error'];
    this.errorDetailed = json['errorDetails'];

    return this;
  }
}
