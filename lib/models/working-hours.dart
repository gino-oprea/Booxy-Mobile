import 'dart:convert';

import './working-day.dart';

class WorkingHours {
  int id;
  int idParent;
  String name;
  WorkingDay monday;
  WorkingDay tuesday;
  WorkingDay wednesday;
  WorkingDay thursday;
  WorkingDay friday;
  WorkingDay saturday;
  WorkingDay sunday;

  WorkingHours(
      {this.id,
      this.idParent,
      this.name,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  WorkingHours clone(WorkingHours objToClone) {
    this.id = objToClone.id;
    this.idParent = objToClone.idParent;
    this.name = objToClone.name;
    this.monday = new WorkingDay().clone(objToClone.monday);
    this.tuesday = new WorkingDay().clone(objToClone.tuesday);
    this.wednesday = new WorkingDay().clone(objToClone.wednesday);
    this.thursday = new WorkingDay().clone(objToClone.thursday);
    this.friday = new WorkingDay().clone(objToClone.friday);
    this.saturday = new WorkingDay().clone(objToClone.saturday);
    this.sunday = new WorkingDay().clone(objToClone.sunday);

    return this;
  }

  WorkingHours fromJson(json) {
    this.id = json['id'];
    this.idParent = json['idParent'];
    this.name = json['name'];
    this.monday = new WorkingDay().fromJson(json['monday']);
    this.tuesday = new WorkingDay().fromJson(json['tuesday']);
    this.wednesday = new WorkingDay().fromJson(json['wednesday']);
    this.thursday = new WorkingDay().fromJson(json['thursday']);
    this.friday = new WorkingDay().fromJson(json['friday']);
    this.saturday = new WorkingDay().fromJson(json['saturday']);
    this.sunday = new WorkingDay().fromJson(json['sunday']);

    return this;
  }

  Map toJson() {
    Map obj = {
      'id': this.id,
      'idParent': this.idParent,
      'name': this.name,
      'monday': this.monday.toJson(),
      'tuesday': this.tuesday.toJson(),
      'wednesday': this.wednesday.toJson(),
      'thursday': this.thursday.toJson(),
      'friday': this.friday.toJson(),
      'saturday': this.saturday.toJson(),
      'sunday': this.sunday.toJson(),
    };

    return obj;
  }
}
