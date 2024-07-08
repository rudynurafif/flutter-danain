import 'package:flutter/services.dart';

class NPWPInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters from the new value
    String cleanedText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Add dots every three digits in the cleaned text
    String formattedText = '';
    for (int i = 0; i < cleanedText.length; i += 3) {
      int endIndex = i + 3;
      if (endIndex > cleanedText.length) {
        endIndex = cleanedText.length;
      }
      formattedText += cleanedText.substring(i, endIndex);
      if (endIndex < cleanedText.length) {
        formattedText += '.';
      }
    }

    // Add the hyphen and the last three digits
    if (formattedText.length > 8) {
      formattedText = formattedText.replaceRange(formattedText.length - 8, formattedText.length, '-${formattedText.substring(formattedText.length - 8)}');
    }

    // Create a new TextEditingValue with the formatted text
    TextEditingValue newFormattedValue = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );

    return newFormattedValue;
  }
}
