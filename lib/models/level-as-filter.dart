import 'dart:convert';

import './entity.dart';

class LevelAsFilter {
  int id;
  int idCompany;
  int orderIndex;
  String levelName_RO;
  String levelName_EN;
  int idLevelType;
  bool isFrontOption;
  bool isMultipleBooking;
  int defaultDuration;
  int idDurationType;
  int entitiesNo;
  List<Entity> entities;

  LevelAsFilter(
      {this.id,
      this.idCompany,
      this.orderIndex,
      this.levelName_RO,
      this.levelName_EN,
      this.idLevelType,
      this.isFrontOption,
      this.isMultipleBooking,
      this.defaultDuration,
      this.idDurationType,
      this.entitiesNo,
      this.entities});

  LevelAsFilter clone(LevelAsFilter objToClone) {
    this.id = objToClone.id;
    this.idCompany = objToClone.idCompany;
    this.orderIndex = objToClone.orderIndex;
    this.levelName_RO = objToClone.levelName_RO;
    this.levelName_EN = objToClone.levelName_EN;
    this.idLevelType = objToClone.idLevelType;
    this.isFrontOption = objToClone.isFrontOption;
    this.isMultipleBooking = objToClone.isMultipleBooking;
    this.defaultDuration = objToClone.defaultDuration;
    this.idDurationType = objToClone.idDurationType;
    this.entitiesNo = objToClone.entitiesNo;

    this.entities = new List<Entity>();
    for (int i = 0; i < objToClone.entities.length; i++) {
      var entity = new Entity().clone(objToClone.entities[i]);

      entities.add(entity);
    }

    return this;
  }

  LevelAsFilter fromJson(Map json) {
    this.id = json['id'];
    this.idCompany = json['idCompany'];
    this.orderIndex = json['orderIndex'];
    this.levelName_RO = json['levelName_RO'];
    this.levelName_EN = json['levelName_EN'];
    this.idLevelType = json['idLevelType'];
    this.isFrontOption = json['isFrontOption'];
    this.isMultipleBooking = json['isMultipleBooking'];
    this.defaultDuration = json['defaultDuration'];
    this.idDurationType = json['idDurationType'];
    this.entitiesNo = json['entitiesNo'];

    this.entities = new List<Entity>();
    List<dynamic> rawEntities = json['entities'];
    for (int i = 0; i < rawEntities.length; i++) {
      var entMap = rawEntities[i];
      var entity = new Entity().fromJson(entMap);

      entities.add(entity);
    }

    return this;
  }

  Map toJson() {
    Map obj = {
      'id': this.id,
      'idCompany': this.idCompany,
      'orderIndex': this.orderIndex,
      'levelName_RO': this.levelName_RO,
      'levelName_EN': this.levelName_EN,
      'idLevelType': this.idLevelType,
      'isFrontOption': this.isFrontOption,
      'isMultipleBooking': this.isMultipleBooking,
      'defaultDuration': this.defaultDuration,
      'idDurationType': this.idDurationType,
      'entitiesNo': this.entitiesNo,
      'entities': this.entities != null ? this.entities.map((e) => e.toJson()).toList() : null
    };

    return obj;
  }
}
