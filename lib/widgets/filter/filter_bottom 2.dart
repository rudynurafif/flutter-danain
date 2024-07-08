import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:hexcolor/hexcolor.dart';

Widget filterItem(
  List<Map<String, dynamic>> dataList,
  int currentItem,
  Function(int) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final int id = data['id'];
      final String name = data['name'];

      return GestureDetector(
        onTap: () {
          handle(id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 1,
                color: currentItem == id
                    ? HexColor(primaryColorHex)
                    : Colors.transparent),
            color: currentItem == id
                ? HexColor(primaryColorHex)
                : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color: currentItem == id ? Colors.white : null,
          ),
        ),
      );
    }).toList(),
  );
}

Widget multipleSelect(
  List<Map<String, dynamic>> dataList,
  List<String> selectedItems,
  Function(List<String>) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final String name = data['name'];
      return GestureDetector(
        onTap: () {
          if (selectedItems.contains(name)) {
            selectedItems.remove(name);
          } else {
            selectedItems.add(name);
          }
          handle(selectedItems);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 1,
                color: selectedItems.contains(name)
                    ? HexColor(primaryColorHex)
                    : Colors.transparent),
            color: selectedItems.contains(name)
                ? HexColor('#E9F6EB')
                : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color:
                selectedItems.contains(name) ? HexColor(primaryColorHex) : null,
          ),
        ),
      );
    }).toList(),
  );
}
