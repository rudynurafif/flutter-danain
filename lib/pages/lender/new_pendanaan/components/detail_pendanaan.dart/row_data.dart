import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../widgets/text/text_widget.dart';

class RowData extends StatelessWidget {
  final String title;
  final String color;
  final String data;

  const RowData({
    super.key,
    required this.title,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: HexColor(color),
        ),
        TextWidget(text: data, fontSize: 12, fontWeight: FontWeight.w500)
      ],
    );
  }
}

class DividerGrey extends StatelessWidget {
  const DividerGrey({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: double.infinity,
      color: HexColor('#EEEEEE'),
    );
  }
}
