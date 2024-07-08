import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/utils/string_format.dart';
import 'package:flutter_danain/utils/type_defs.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class DateForm extends StatelessWidget {
  final String? data;
  final Function1<dynamic, void> onSelect;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  const DateForm({
    super.key,
    this.data,
    required this.onSelect,
    this.minDateTime,
    this.maxDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final date = data ?? DateTime.now().toString();
    final dateFormat = dateSurvey(date);
    DateTime now = DateTime.now();
    DateTime todayMidnight = DateTime(now.year, now.month, now.day);
    final widget = data != null
        ? TextWidget(
            text: dateFormat,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          )
        : TextWidget(
            text: 'DD/MM/YYYY',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: HexColor('#AAAAAA'),
          );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BottomPicker.date(
          dateOrder: DatePickerDateOrder.dmy,
          buttonWidth: MediaQuery.of(context).size.width - 80,
          buttonContent: const TextWidget(
            text: 'Pilih',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            align: TextAlign.center,
          ),
          titlePadding: const EdgeInsets.symmetric(vertical: 12),
          titleAlignment: Alignment.center,
          buttonStyle: BoxDecoration(
            color: HexColor(primaryColorHex),
            borderRadius: BorderRadius.circular(8),
          ),
          initialDateTime: data != null ? DateTime.parse(data!) : null,
          minDateTime: todayMidnight,
          maxDateTime: maxDateTime,
          onSubmit: onSelect,
          pickerTitle: Container(),
        ).show(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: HexColor('#DDDDDD'),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget,
            Icon(
              Icons.calendar_today,
              size: 16,
              color: HexColor('#AAAAAA'),
            )
          ],
        ),
      ),
    );
  }
}

class TimeForm extends StatelessWidget {
  final String? data;
  final Function1<dynamic, void> onSelect;

  const TimeForm({
    Key? key,
    this.data,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = data ?? DateTime.now().toString();
    final d = DateTime.parse(date);

    final dateFormat = timeSurvey(d);
    final widget = data != null
        ? TextWidget(
            text: dateFormat,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          )
        : TextWidget(
            text: 'HH:mm',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: HexColor('#AAAAAA'),
          );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BottomPicker.time(
          use24hFormat: true,
          buttonWidth: MediaQuery.of(context).size.width - 80,
          buttonContent: const TextWidget(
            text: 'Pilih',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            align: TextAlign.center,
          ),
          minTime: Time(hours: 8, minutes: 30),
          maxTime: Time(hours: 17, minutes: 0),
          titleAlignment: Alignment.center,
          titlePadding: const EdgeInsets.symmetric(vertical: 12),
          buttonStyle: BoxDecoration(
            color: HexColor(primaryColorHex),
            borderRadius: BorderRadius.circular(8),
          ),
          initialTime: timeBuilder(d),
          onSubmit: onSelect,
          pickerTitle: Container(),
        ).show(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: HexColor('#DDDDDD'),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget,
            Icon(
              Icons.access_time,
              size: 16,
              color: HexColor('#AAAAAA'),
            )
          ],
        ),
      ),
    );
  }

  Time timeBuilder(DateTime d) {
    if (d.hour >= 17) {
      return Time(hours: 17, minutes: 0);
    }
    if (d.hour <= 8) {
      return Time(hours: 8, minutes: 30);
    }
    return Time(hours: d.hour, minutes: d.minute);
  }

  String timeSurvey(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }
}
