import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

Widget caraBayarDetail(BuildContext context, List<dynamic> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return Container(
          margin: EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: HexColor(primaryColorHex)),
                    padding: const EdgeInsets.all(4),
                    width: 25,
                    height: 25,
                    child: Subtitle3(
                      text: '${index + 1}',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Subtitle2(
                      text: item,
                      color: HexColor('#555555'),
                    ),
                  )
                ],
              ),
              if (index != data.length - 1)
                Column(
                  children: [
                    SizedBox(height: 8),
                    dividerDashed(context),
                  ],
                ),
            ],
          ));
    }).toList(),
  );
}

Widget caraBayarDetailLender(BuildContext context, List<String> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: HexColor(lenderColor)),
                    padding: const EdgeInsets.all(4),
                    width: 25,
                    height: 25,
                    child: Subtitle3(
                      text: '${index + 1}',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Subtitle2(
                      text: item,
                      color: HexColor('#555555'),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              dividerDashed(context)
            ],
          ));
    }).toList(),
  );
}

Widget listCheck(BuildContext context, List<String> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.asMap().entries.map((entry) {
      final item = entry.value;
      return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: HexColor('#E8F7EE'),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Subtitle2(
                      text: item,
                      color: HexColor('#777777'),
                    ),
                  ),
                ],
              ),
            ],
          ));
    }).toList(),
  );
}

Widget listStrip(BuildContext context, List<dynamic> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.asMap().entries.map((entry) {
      final item = entry.value;
      return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(text: '-'),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Subtitle2(
                      text: item,
                      color: HexColor('#777777'),
                    ),
                  ),
                ],
              ),
            ],
          ));
    }).toList(),
  );
}

Widget listNumber(BuildContext context, List<String> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.asMap().entries.map((entry) {
      int index = entry.key + 1;
      String text = entry.value;
      return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(
                    text: '${index.toString()}.',
                    color: HexColor('#777777'),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Subtitle2(
                      text: text,
                      color: HexColor('#777777'),
                    ),
                  ),
                ],
              ),
            ],
          ));
    }).toList(),
  );
}
