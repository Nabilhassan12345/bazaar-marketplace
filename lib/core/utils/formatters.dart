import 'package:intl/intl.dart';

abstract final class Formatters {
  static String formatPrice(double amount) {
    final hasCents = amount % 1 != 0;
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: hasCents ? 2 : 0,
    ).format(amount);
  }
}
