import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

Widget caraBayarDetail(BuildContext context,List<String> data) {
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
                  Subtitle2(
                    text: item,
                    color: HexColor('#555555'),
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
