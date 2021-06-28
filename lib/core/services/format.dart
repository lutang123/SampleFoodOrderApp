import 'package:intl/intl.dart';

NumberFormat _currencyFormat = NumberFormat("#,##0.00", "en_US");

String currency(int price) {
  return "\$${_currencyFormat.format(price / 100)}";
}
