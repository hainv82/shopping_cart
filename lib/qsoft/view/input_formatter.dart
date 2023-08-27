import 'package:flutter/services.dart';
import 'package:shopping_cart/helper/price_formatter.dart';

class QuantityFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final quantity = int.parse(newValue.text);
    var newText = quantity > 0 ? newValue.text : oldValue.text;
    if (quantity > 999) {
      newText = '999';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'[.đ]'), '');
    final price = double.tryParse(newText) ?? 0;
    final priceText = PriceFormatter().formatPrice(price);

    return newValue.copyWith(
      text: priceText,
      selection: TextSelection.collapsed(offset: priceText.length - 1),
    );
  }
}
