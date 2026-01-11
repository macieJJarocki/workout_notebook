import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TODO
// restrict date must be lower than the DateTime.now().month,
// but bear in mind that there must be some kind of the checker
// to verify if there is workout has been assigned to the calendar on that date
// DateService({required DateTime dateNow})
class DateService {
  DateService({required DateTime dateNow})
    : date = DateTime(dateNow.year, dateNow.month);

  DateTime date;

  //  Return the numer of days in the mounth based on the provided month
  int daysInMonth({int? month}) {
    return DateUtils.getDaysInMonth(date.year, month ?? date.month);
  }


// TODO Add Local to the settings bloc
  String dateAsString({String? locale}) =>
      DateFormat.yMMMM(locale).format(date).toString();
}
