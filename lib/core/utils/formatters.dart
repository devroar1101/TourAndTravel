import 'package:intl/intl.dart';

/// Formatting helpers shared by the public site and admin panel.
class Formatters {
  Formatters._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final DateFormat _date = DateFormat('d MMM yyyy');
  static final DateFormat _dateTime = DateFormat('d MMM yyyy, h:mm a');
  static final DateFormat _monthShort = DateFormat('MMM');

  static String price(num value) => _inr.format(value);

  static String compactCount(num value) =>
      NumberFormat.compact().format(value);

  static String date(DateTime value) => _date.format(value);

  static String dateTime(DateTime value) => _dateTime.format(value.toLocal());

  static String monthShort(DateTime value) => _monthShort.format(value);

  static String duration(int days, int nights) => '$days D · $nights N';
}
