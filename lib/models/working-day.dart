class WorkingDay {
  String workHours;
  DateTime date;

  WorkingDay({this.workHours, this.date});

  WorkingDay fromJson(json) {
    this.workHours = json['workHours'];
    this.date = json['date'] == null ? null : DateTime.parse(json['date']);

    return this;
  }
}
