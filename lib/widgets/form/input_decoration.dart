import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../text/subtitle.dart';

InputDecoration inputDecorWithIcon(
    BuildContext context, String hintText, bool error, IconData icon) {
  return InputDecoration(
    errorText: error ? '' : null,
    hintText: hintText,
    suffixIcon: Icon(
      icon,
      size: 16,
      color: HexColor('#BEBEBE'),
    ),
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff288C50),
        width: 1.0,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecorWithIconSvg(
  BuildContext context,
  String hintText,
  bool error,
  String icon,
) {
  return InputDecoration(
    errorText: error ? '' : null,
    hintText: hintText,
    suffixIcon: SvgPicture.asset(
      icon,
      width: 16,
      height: 21,
      fit: BoxFit.scaleDown,
    ),
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff288C50),
        width: 1.0,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecor(BuildContext context, String hintText, bool error) {
  return InputDecoration(
    errorText: error ? '' : null,
    hintText: hintText,
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff288C50),
        width: 1.0,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecorLender(BuildContext context, String hintText, bool error) {
  return InputDecoration(
    errorText: error ? '' : null,
    hintText: hintText,
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: HexColor(lenderColor),
        width: 1.0,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecorErrorLeft(
  BuildContext context,
  String hintText,
  bool errorText,
) {
  return InputDecoration(
    errorText: errorText ? '' : null,
    hintText: hintText,
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff288C50),
        width: 1.0,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecorNoError(BuildContext context, String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff288C50),
        width: 1.0,
      ),
    ),
    fillColor: Colors.grey,
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecorNoErrorLender(BuildContext context, String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: HexColor(lenderColor),
        width: 1.0,
      ),
    ),
    fillColor: Colors.grey,
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecorWithSuffixAndSetHeight(
    BuildContext context, String hintText, String suffix) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
    ),
    suffixStyle: TextStyle(color: HexColor('#333333')),
    suffixText: suffix,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    isDense: true,
    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff288C50),
        width: 1.0,
      ),
    ),
    fillColor: Colors.grey,
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}

InputDecoration inputDecorSetHeight(BuildContext context, String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: HexColor('#BEBEBE'),
      fontSize: 14,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffDDDDDD),
        width: 1.0,
      ),
    ),
    // isDense: true,
    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 247, 4, 4),
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff288C50),
        width: 1.0,
      ),
    ),
    fillColor: Colors.grey,
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    prefixIcon: const Padding(
      padding: EdgeInsets.only(left: 16, right: 4),
      child: SubtitleExtra(
        text: 'Rp',
      ),
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
  );
}
