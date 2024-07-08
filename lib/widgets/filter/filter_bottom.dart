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
                color: currentItem == id ? HexColor(primaryColorHex) : Colors.transparent),
            color: currentItem == id ? HexColor(primaryColorHex) : HexColor('#EEEEEE'),
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

Widget filterItemLender(
  List<dynamic> dataList,
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
                width: 1, color: currentItem == id ? HexColor(lenderColor) : Colors.transparent),
            color: currentItem == id ? HexColor(lenderColor) : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color: currentItem == id ? Colors.white : HexColor('#777777'),
          ),
        ),
      );
    }).toList(),
  );
}

Widget filterItemString(
  List<Map<String, dynamic>> dataList,
  String currentItem,
  Function(String) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final String id = data['id'];
      final String name = data['nama'];

      return GestureDetector(
        onTap: () {
          handle(id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 1, color: currentItem == id ? HexColor(lenderColor) : Colors.transparent),
            color: currentItem == id ? HexColor(lenderColor) : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color: currentItem == id ? Colors.white : HexColor('#777777'),
          ),
        ),
      );
    }).toList(),
  );
}

Widget filterItemStringBorrower(
  List<Map<String, dynamic>> dataList,
  String currentItem,
  Function(String) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final String id = data['id'];
      final String name = data['nama'];

      return GestureDetector(
        onTap: () {
          handle(id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 1, color: currentItem == id ? HexColor('#24663F') : Colors.transparent),
            color: currentItem == id ? HexColor('#24663F') : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color: currentItem == id ? Colors.white : HexColor("#777777"),
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
      final String name = data['id'];
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
                color:
                    selectedItems.contains(name) ? HexColor(primaryColorHex) : Colors.transparent),
            color: selectedItems.contains(name) ? HexColor('#E9F6EB') : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: data['name'],
            color: selectedItems.contains(name) ? HexColor(primaryColorHex) : null,
          ),
        ),
      );
    }).toList(),
  );
}

Widget multipleSelectLender(
  List<Map<String, dynamic>> dataList,
  List<String> selectedItems,
  Function(List<String>) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final String id = data['id'];
      final String name = data['name'];

      return FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? 1;
          return GestureDetector(
            onTap: () {
              if (selectedItems.contains(id)) {
                selectedItems.remove(id);
              } else {
                selectedItems.add(id);
              }
              handle(selectedItems);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 1,
                  color: selectedItems.contains(id)
                      ? data == 2
                          ? HexColor(primaryColorHex)
                          : HexColor(lenderColor)
                      : Colors.transparent,
                ),
                color: selectedItems.contains(id) ? HexColor('#E9F6EB') : HexColor('#EEEEEE'),
              ),
              child: Subtitle2(
                text: name,
                color: selectedItems.contains(id)
                    ? data == 2
                        ? HexColor(primaryColorHex)
                        : HexColor(lenderColor)
                    : HexColor("#777777"),
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}

Widget multipleSelectJenisProduk(
  List<dynamic> dataList,
  List<int> selectedItems,
  Function(List<int>) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final int id = data['idProduk'];
      final String name = data['namaProduk'];
      return GestureDetector(
        onTap: () {
          if (selectedItems.contains(id)) {
            selectedItems.remove(id);
          } else {
            selectedItems.add(id);
          }
          handle(selectedItems);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 1,
                color: selectedItems.contains(id) ? HexColor(lenderColor) : Colors.transparent),
            color: selectedItems.contains(id) ? HexColor('#E9F6EB') : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color: selectedItems.contains(id) ? HexColor(lenderColor) : HexColor('#777777'),
          ),
        ),
      );
    }).toList(),
  );
}

Widget multipleSelectJenisEmas(
  List<dynamic> dataList,
  List<int> selectedItems,
  Function(List<int>) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final int id = data['idJenisEmas'];
      final String name = data['namaJenisEmas'];
      return GestureDetector(
        onTap: () {
          if (selectedItems.contains(id)) {
            selectedItems.remove(id);
          } else {
            selectedItems.add(id);
          }
          handle(selectedItems);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 1,
                color: selectedItems.contains(id) ? HexColor(lenderColor) : Colors.transparent),
            color: selectedItems.contains(id) ? HexColor('#E9F6EB') : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color: selectedItems.contains(id) ? HexColor(lenderColor) : null,
          ),
        ),
      );
    }).toList(),
  );
}

Widget multipleSelectLenderString(
  List<dynamic> dataList,
  List<String> selectedItems,
  Function(List<String>) handle,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: dataList.map((data) {
      final String id = data['id'];
      final String name = data['nama'];
      return GestureDetector(
        onTap: () {
          if (selectedItems.contains(id)) {
            selectedItems.remove(id);
          } else {
            selectedItems.add(id);
          }
          handle(selectedItems);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 1,
                color: selectedItems.contains(id) ? HexColor(lenderColor) : Colors.transparent),
            color: selectedItems.contains(id) ? HexColor('#E9F6EB') : HexColor('#EEEEEE'),
          ),
          child: Subtitle2(
            text: name,
            color: selectedItems.contains(id) ? HexColor(lenderColor) : HexColor('#777777'),
          ),
        ),
      );
    }).toList(),
  );
}
