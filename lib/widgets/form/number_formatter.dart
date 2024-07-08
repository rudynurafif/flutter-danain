import 'package:flutter/services.dart';

class CantZero extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }
    if (text.startsWith('0')) {
      return oldValue;
    }

    // Remove non-digit characters and parse the value
    int value = int.tryParse(text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    // Check if the value is less than 0 and prevent typing if it is
    if (value < 0) {
      return oldValue;
    }

    return newValue;
  }
}

class LessThan160 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }
    if (text.length > 160) {
      return oldValue;
    }

    return newValue;
  }
}
