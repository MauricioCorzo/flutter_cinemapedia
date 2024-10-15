import 'package:intl/intl.dart';

class CustomDateFormatter {
  static String date(String pattern, DateTime date) {
    final formatterDate = DateFormat(pattern).format(date);

    return formatterDate;
  }
}
