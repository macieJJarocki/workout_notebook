import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateService {
  DateService({required DateTime dateNow})
    : date = DateTime(dateNow.year, dateNow.month);

  DateTime date;

  //  Return the numer of days in the mounth based on the provided month
  int daysInMonth({int? month}) {
    return DateUtils.getDaysInMonth(date.year, month ?? date.month);
  }

  // TODO Add Local to the settings bloc
  // Return [this.date] or [date] as String formated with provided pattern and locale.
  String dateAsString({
    required String pattern,
    required String locale,
    DateTime? date,
  }) => DateFormat(pattern, locale).format(date ?? this.date);

  // Return true if [other] represent date creted in the same day[DateTime.now()] or after return true else return false.
  bool compareDates(DateTime other) {
    final now = DateTime.now();
    if (other.month == now.month) {
      if (other.day < now.day) {
        return false;
      }
    }
    return true;
  }
}
