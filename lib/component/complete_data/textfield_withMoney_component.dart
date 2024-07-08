import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

Widget formMoney(
  BuildContext context,
  TextEditingController controller,
  String hintText,
) {
  return TextFormField(
    style: const TextStyle(color: Colors.black),
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly, NumberTextInputFormatter()],
    decoration: InputDecoration(
      hintText: hintText,
      prefixStyle: const TextStyle(color: Colors.black),
      hintStyle: TextStyle(color: HexColor('#BEBEBE')),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffDDDDDD),
          width: 1.0,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff288C50),
          width: 1.0,
        ),
      ),
    ),
    controller: controller,
  );
}

class NumberTextInputFormatterLimit extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // Format the input as a currency value with Rupiah.
    final formattedText = NumberFormat.currency(
      symbol: 'Rp ',
      locale: 'id_ID',
      decimalDigits: 0,
    ).format(double.tryParse(text));

    final formatLimit = NumberFormat.currency(
      symbol: 'Rp ',
      locale: 'id_ID',
      decimalDigits: 0,
    ).format(1);

    if (formattedText.length > 20 || formattedText.length <= 3) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove non-digit characters
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse the text to a number
    double value = double.tryParse(text) ?? 0;

    // Format the input as a currency value with Rupiah.
    final formattedText = NumberFormat.currency(
      symbol: 'Rp ',
      locale: 'id_ID',
      decimalDigits: 0,
    ).format(value);

    if (formattedText.length > 20) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}

class NumberTextInputFormatter2 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove non-digit characters
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse the text to a number
    double value = double.tryParse(text) ?? 0;

    // Format the input as a currency value with Rupiah.
    final formattedText = NumberFormat.currency(
      symbol: '',
      locale: 'id_ID',
      decimalDigits: 0,
    ).format(value);

    if (formattedText.length > 20) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}

class NumberTextInputFormatterWithMax extends TextInputFormatter {
  final num maxValue;

  NumberTextInputFormatterWithMax(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // Format the input as a currency value with Rupiah.
    final formattedText = NumberFormat.currency(
      symbol: 'Rp ',
      locale: 'id_ID',
      decimalDigits: 0,
    ).format(double.tryParse(text) ?? 0);

    final numericValue = double.tryParse(text.replaceAll(RegExp('[^0-9]'), '')) ?? 0;

    // Check if the numeric value exceeds the maximum value
    if (numericValue > maxValue) {
      // If yes, set the text field value to the maximum value
      return TextEditingValue(
        text: NumberFormat.currency(
          symbol: 'Rp ',
          locale: 'id_ID',
          decimalDigits: 0,
        ).format(maxValue),
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    if (formattedText.length > 20) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}

class NoLeadingSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure that the new value does not start with a space
    if (newValue.text.isNotEmpty && newValue.text[0] == ' ') {
      return oldValue; // Reject the change
    }
    return newValue; // Accept the change
  }
}
