import 'dart:convert';

class GenericResponseObject<T> {
  List<T> objList;
  String info;
  String error;
  String errorDetailed;

  GenericResponseObject(
      {this.objList, this.info, this.error, this.errorDetailed});

  GenericResponseObject fromJson(Map json) {
    this.objList = json['objList'] as List<T>;
    // if (rawObjList != null)
    //   for (int i = 0; i < rawObjList.length; i++) {
    //     var objMap = rawObjList[i];
    //     var obj = objMap.runtimeType.fromJson(objMap);

    //     objList.add(obj);
    //   }
    T t = createInstance(T);
    this.info = json['info'];
    this.error = json['error'];
    this.errorDetailed = json['errorDetails'];

    return this;
  }
}
