import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class ErrorText extends StatelessWidget {
  final String? error;
  const ErrorText({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: TextWidget(
                text: error!,
                color: Colors.red,
                fontSize: 12,
                align: TextAlign.right,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
