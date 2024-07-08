import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

Widget alertDataAman(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Color(0xffE9F6EB), borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.safety_check_rounded,
            size: 16, color: HexColor(primaryColorHex)),
        SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline5(text: 'Data Anda Dijamin Aman'),
              SizedBox(height: 2),
              Subtitle3(
                text:
                    'Kami meminta data sesuai dengan peraturan OJK. Data tidak akan diberikan kepada siapapun tanpa persetujuan Anda.',
                color: HexColor('#777777'),
              ),
            ],
          ),
        )
      ],
    ),
  );
}