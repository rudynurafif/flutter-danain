import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../widgets/text/text_widget.dart';

class ModalTitle extends StatelessWidget {
  final String title;

  const ModalTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: HexColor('#AAAAAA'),
            ),
          )
        ],
      ),
    );
  }
}
