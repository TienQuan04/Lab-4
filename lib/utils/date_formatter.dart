import 'package:intl/intl.dart';

class DateFormatter {
  static String formatHour(DateTime dateTime, {bool is24h = true}) {
    final pattern = is24h ? 'HH:mm' : 'hh:mm a';
    return DateFormat(pattern).format(dateTime);
  }
  
  static String formatShortDay(DateTime dateTime) {
    return DateFormat('EEE').format(dateTime);
  }

  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM d').format(dateTime);
  }
}
