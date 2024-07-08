import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../data/constants.dart';
import '../../utils/constants.dart';
import '../../utils/date_helper.dart';
import '../../utils/type_defs.dart';
import '../button/button.dart';
import '../space_h.dart';
import '../space_v.dart';
import '../text/text_widget.dart';

class DateFilter extends StatefulWidget {
  final int year;
  final int month;
  final Function2<int, int, void> onSelect;
  const DateFilter({
    super.key,
    required this.year,
    required this.month,
    required this.onSelect,
  });

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool isDropdown = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedYear = widget.year;
      selectedMonth = widget.month;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isDropdown = !isDropdown;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    TextWidget(
                      text: selectedYear.toString(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SpacerH(value: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 12,
                      color: Color(0xff131324),
                    ),
                  ],
                ),
              ),
            ),
            monthWidget(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Button(
                  title: 'Batal',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  paddingY: 11,
                  color: Colors.white,
                  borderColor: HexColor(lenderColor),
                  width: MediaQuery.of(context).size.width / 2.9,
                  titleColor: HexColor(lenderColor),
                ),
                Button(
                  title: 'Simpan',
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSelect(selectedMonth, selectedYear);
                  },
                  paddingY: 11,
                  color: HexColor(lenderColor),
                  width: MediaQuery.of(context).size.width / 2.9,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget monthWidget(BuildContext context) {
    final List<String> listYear = getListYear(DateTime.now().year - 20).reversed.toList();
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              const SpacerV(value: 12),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: Constants.get.listMonth.map(
                  (data) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isDropdown = false;
                          selectedMonth = data['bulan'] as int;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4.3,
                        margin: const EdgeInsets.only(bottom: 16),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: selectedMonth == data['bulan']
                              ? HexColor(lenderColor)
                              : DateTime.now().month == data['bulan']
                                  ? const Color(0xffF5F6F7)
                                  : Colors.white,
                        ),
                        child: TextWidget(
                          text: data['nama'].toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color:
                              selectedMonth == data['bulan'] ? Colors.white : HexColor('#7E7E7E'),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isDropdown,
          child: Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width / 5,
            height: 150,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listYear.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      isDropdown = false;
                      selectedYear = int.tryParse(listYear[index])!;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: selectedYear.toString() == listYear[index]
                          ? HexColor(lenderColor)
                          : DateTime.now().year.toString() == listYear[index]
                              ? const Color(0xffF5F6F7)
                              : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: TextWidget(
                      text: listYear[index],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: selectedYear.toString() == listYear[index]
                          ? Colors.white
                          : const Color(0xff2D3748),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
