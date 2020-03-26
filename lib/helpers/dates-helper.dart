import 'package:intl/intl.dart';

class DatesHelper {
  static List<String> getWeekDates(DateTime date) {
    var weekDay = date.weekday;

    var monday = date.add(new Duration(days: 1 - weekDay));
    var tuesday = date.add(new Duration(days: 2 - weekDay));
    var wednesday = date.add(new Duration(days: 3 - weekDay));
    var thursday = date.add(new Duration(days: 4 - weekDay));
    var friday = date.add(new Duration(days: 5 - weekDay));
    var saturday = date.add(new Duration(days: 6 - weekDay));
    var sunday = date.add(new Duration(days: 7 - weekDay));

    List<String> dates = [];

    dates.add(getDateString(monday));
    dates.add(getDateString(tuesday));
    dates.add(getDateString(wednesday));
    dates.add(getDateString(thursday));
    dates.add(getDateString(friday));
    dates.add(getDateString(saturday));
    dates.add(getDateString(sunday));

    return dates;
  }

  static String getDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
