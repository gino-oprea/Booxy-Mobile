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
}
