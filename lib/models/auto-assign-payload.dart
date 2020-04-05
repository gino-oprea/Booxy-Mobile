import './timeslot.dart';

import './level-as-filter.dart';

class AutoAssignPayload {
  List<LevelAsFilter> selectedLevels;
  List<List<Timeslot>> bookingDayTimeslots;

  AutoAssignPayload({this.selectedLevels, this.bookingDayTimeslots});

  Map toJson() {
    Map obj = {
      'selectedLevels': this.selectedLevels != null
          ? this.selectedLevels.map((l) => l.toJson()).toList()
          : null,
      'bookingDayTimeslots': this.bookingDayTimeslots != null
          ? this
              .bookingDayTimeslots
              .map((tt) => tt.map((t) => t.toJson()).toList())
              .toList()
          : null
    };

    return obj;
  }
}
