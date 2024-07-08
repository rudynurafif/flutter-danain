import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.color,
    this.align,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      textAlign: align ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
