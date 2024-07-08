import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

Widget logoAndName(String initial, String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 32,
        width: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: HexColor('#E9F6EB'),
        ),
        child: Headline3500(
          text: initial,
          color: HexColor(primaryColorHex),
        ),
      ),
      const SizedBox(width: 8),
      Headline3500(text: name),
    ],
  );
}

String getInitialName(String text) {
  List<String> words = text.split(' ');
  List<String> firstCharacters = [];

  for (String word in words) {
    if (word.isNotEmpty) {
      firstCharacters.add(word[0]);
    }
  }

  return firstCharacters.join('');
}