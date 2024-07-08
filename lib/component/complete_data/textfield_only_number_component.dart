import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

Widget formOnlyNumber(
    BuildContext context, TextEditingController controller, String hintText) {
  return TextFormField(
    style: TextStyle(color: Colors.black),
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: HexColor('#BEBEBE')),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffDDDDDD),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff288C50),
          width: 1.0,
        ),
      ),
    ),
    controller: controller,
  );
}
