import 'package:intl/intl.dart';

class PriceFormatter {
  factory PriceFormatter() => _instance;

  PriceFormatter._internal();

  static final PriceFormatter _instance = PriceFormatter._internal();

  final formatter = NumberFormat('#,000', 'vi');

  String formatPrice(double price, [bool noSign = false]) {
    if (price > 0) {
      if (price < 1000) {
        return '${price.toStringAsFixed(0)}${!noSign ? 'đ' : ''}';
      }
      return '${formatter.format(price)}${!noSign ? 'đ' : ''}';
    }
    return '0${!noSign ? 'đ' : ''}';
  }
}
