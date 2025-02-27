// lib/utils/currency_formatter.dart

import 'package:intl/intl.dart';

String formatCurrency(double amount, {bool showDecimal = true}) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: showDecimal ? 2 : 0,
  );

  return formatter.format(amount);
}
