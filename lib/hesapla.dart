import 'package:intl/intl.dart';

class Hesapla {
  static String dateTimeToString(DateTime dateTime) {
    String formatttedDate = DateFormat('dd/ MM/ yyyy').format(dateTime);
    return formatttedDate;
  }
}
