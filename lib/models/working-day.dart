class WorkingDay {
  String workHours;
  DateTime date;

  WorkingDay({this.workHours, this.date});

  WorkingDay clone(WorkingDay objToClone) {
    this.workHours = objToClone.workHours;
    this.date = new DateTime(
        objToClone.date.year, objToClone.date.month, objToClone.date.day);

    return this;
  }

  WorkingDay fromJson(json) {
    this.workHours = json['workHours'];
    this.date = json['date'] == null ? null : DateTime.parse(json['date']);

    return this;
  }
}
