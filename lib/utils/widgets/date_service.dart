class DateService {
  DateService._();
  static final DateTime _now = DateTime.now();
  static DateTime get now => _now;
  static int get year => _now.year;
  static int get month => _now.month;
  static int get day => _now.day;
}
