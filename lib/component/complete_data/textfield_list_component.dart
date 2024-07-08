import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';


Widget formDataWidget(BuildContext context, TextEditingController controller,
    String hintText, bool iconShow) {
  return TextFormField(
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: HexColor('#BEBEBE')),
      suffixIcon: iconShow
          ? SvgPicture.asset(
              'assets/images/icons/dropdown.svg',
              width: 16,
              height: 21,
              fit: BoxFit.scaleDown,
            )
          : null,
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