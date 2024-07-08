import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/component/complete_data/textfield_withMoney_component.dart';

class OnlyNumberForm extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeHolder;
  final void Function(String?)? submitResponse;
  final void Function(String?)? changeResponse;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  final String? prefix;
  const OnlyNumberForm(
      {super.key, required this.label,
      required this.controller,
      required this.placeHolder,
      this.submitResponse,
      this.validator,
      this.changeResponse,
      required this.focusNode,
      this.prefix});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xffAAAAAA)),
        ),
        const SizedBox(height: 4.0),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.number,
          controller: controller,
          onChanged: changeResponse,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: const OutlineInputBorder(),
            prefixStyle: const TextStyle(color: Colors.black),
            prefixText: prefix,
            hintText: placeHolder,
            hintStyle: const TextStyle(color: Color(0xffDDDDDD)),
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
          validator: validator,
          onFieldSubmitted: submitResponse,
          focusNode: focusNode,
        ),
        )
      ],
    );
  }
}
class NumericRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Parse the new value as an integer
    int? value = int.tryParse(newValue.text);

    if (value == null) {
      // If parsing fails, return the old value
      return newValue;
    }

    // Check if the value is within the specified range
    if (value < min) {
     value = null;
    } else if (value > max) {
      value = max;
    }

    // Create a new TextEditingValue with the updated value
    return TextEditingValue(
      text: value.toString(),
      selection: TextSelection.collapsed(offset: value.toString().length),
    );
  }
}

class OnlyNumberForm40 extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeHolder;
  final void Function(String?)? submitResponse;
  final void Function(String?)? changeResponse;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  final String? prefix;
  final int maxValue;

  const OnlyNumberForm40(
      {super.key, required this.label,
      required this.controller,
      required this.placeHolder,
      this.submitResponse,
      this.validator,
      this.changeResponse,
      required this.focusNode,
      this.prefix,
        required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        const SizedBox(height: 4.0),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: TextFormField(
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.number,
          controller: controller,
          onChanged: changeResponse,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly,  NumericRangeFormatter(min: 0, max: maxValue, ),NumberTextInputFormatter(), ],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: const OutlineInputBorder(),
            prefixStyle: const TextStyle(color: Colors.black),
            prefixText: prefix,
            hintText: placeHolder,
            hintStyle: const TextStyle(color: Colors.grey),
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
          validator: validator,
          onFieldSubmitted: submitResponse,
          focusNode: focusNode,
        ),
        )
      ],
    );
  }
}
