import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

import '../text/subtitle.dart';

Widget keyVal(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(text: key, color: HexColor('#AAAAAA')),
      Subtitle2(text: val, color: HexColor('#333333'))
    ],
  );
}

Widget keyValLoading(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShimmerLong(height: 20, width: MediaQuery.of(context).size.width / 3.5),
      ShimmerLong(height: 20, width: MediaQuery.of(context).size.width / 2.5),
    ],
  );
}

Widget keyVal12500(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2Extra(text: key, color: HexColor('#333333')),
      Subtitle2Extra(text: val, color: HexColor('#333333'))
    ],
  );
}

Widget keyVal13400(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle1(text: key, color: HexColor('#777777')),
      Subtitle2(text: val, color: HexColor('#333333'))
    ],
  );
}

Widget keyValIcon(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle500(text: key, color: HexColor('#333333')),
      Container(
        margin: EdgeInsets.only(left: 4), // Adjust the left margin as needed
        child: Subtitle500(text: '>', color: HexColor('#288C50')),
      ),
    ],
  );
}

Widget keyValExtra(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(text: key, color: HexColor('#777777')),
      Subtitle2Extra(text: val, color: HexColor('#333333'))
    ],
  );
}

Widget keyVal7(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(text: key, color: HexColor('#777777')),
      Subtitle2(text: val, color: HexColor('#333333'))
    ],
  );
}

Widget keyVal8(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(text: key, color: HexColor('#777777')),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: HexColor('#EEEEEE')),
          child: Subtitle2(text: val, color: HexColor('#777777')))
    ],
  );
}

Widget keyValHeader(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Headline3500(text: key), Headline3500(text: val)],
  );
}

Widget keyValHeaderRiwayatTrans(
  String key,
  String kdTrans,
  String val,
  int statusWd,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Headline5(text: key),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Headline4500(
            text: val,
            color: kdTrans == 'PNP' || kdTrans == 'WTH' || kdTrans == 'PPH23'
                ? HexColor('#EB5757')
                : HexColor('#28AF60'),
          ),
        ],
      )
    ],
  );
}

Widget keyValHeaderRiwayatTrans2(String keterangan, String kdTrans, String nominal, String noPP) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Headline5(text: keterangan),
          Headline4500(
            text: nominal,
            color: kdTrans == 'PNP' || kdTrans == 'WTH' || kdTrans == 'PPH23'
                ? HexColor('#EB5757')
                : HexColor('#28AF60'),
          )
        ],
      ),
      if (keterangan != 'Setor Dana' && keterangan != 'Tarik Dana')
        Column(
          children: [
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtitle2(
                  text: 'No PP. $noPP',
                  color: const Color(0xFFAAAAAA),
                ),
              ],
            ),
          ],
        ),
    ],
  );
}

Widget keyValTarikDana(
  String tanggal,
  String status,
) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Subtitle2(
            text: tanggal,
            color: const Color(0xFFAAAAAA),
          ),
          if (status != 'Berhasil')
            Subtitle3(
              text: 'Dalam Proses',
              color: HexColor('#F7951D'),
            ),
        ],
      ),
    ],
  );
}

Widget keyValHeader2(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SubtitleExtra(
        text: key,
        color: HexColor('#777777'),
      ),
      Headline3500(text: val)
    ],
  );
}

Widget keyVal2(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(text: key, color: HexColor('#AAAAAA')),
      SizedBox(
        width: 200,
        child: Flexible(
          child: Subtitle2Large(
            text: val,
            align: TextAlign.end,
          ),
        ),
      )
    ],
  );
}

Widget keyVal2Margin(String key, String val, {double marginLeft = 0.0}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(text: key, color: HexColor('#AAAAAA')),
      Flexible(
          child: Subtitle2Large(
        text: val,
        align: TextAlign.end,
      ))
    ],
  );
}

Widget keyVal2Modified(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(text: key, color: HexColor('#AAAAAA')),
      Flexible(
          child: Subtitle2LargeModified(
        text: val,
        align: TextAlign.end,
      ))
    ],
  );
}

Widget keyVal3(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Subtitle2Large(text: key), Subtitle2Large(text: val)],
  );
}

Widget keyVal4(String key, String val) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(
        text: key,
        color: HexColor('#777777'),
      ),
      Headline3500(text: val)
    ],
  );
}

Widget keyValVertical(String key, String val) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle3(
        text: key,
        color: HexColor('#AAAAAA'),
      ),
      const SizedBox(height: 4),
      SubtitleExtra(text: val)
    ],
  );
}

Widget keyValVerticalLoading(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShimmerLong(height: 20, width: MediaQuery.of(context).size.width / 3),
      const SizedBox(height: 4),
      ShimmerLong(height: 20, width: MediaQuery.of(context).size.width / 2),
    ],
  );
}

class KeyValGeneral extends StatelessWidget {
  final String title;
  final String value;
  const KeyValGeneral({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: HexColor('#777777'),
        ),
        TextWidget(
          text: value,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

class KeyValGeneralMedium extends StatelessWidget {
  final String title;
  final String value;
  const KeyValGeneralMedium({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        TextWidget(
          text: value,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

class KeyValTitle extends StatelessWidget {
  final String title;
  final String value;
  const KeyValTitle({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: HexColor('#777777'),
        ),
        TextWidget(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class KeyValVertical extends StatelessWidget {
  final String title;
  final String value;
  const KeyValVertical({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: title,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: HexColor('#AAAAAA'),
        ),
        const SpacerV(value: 4),
        TextWidget(
          text: value,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class KeyValTitleMedium extends StatelessWidget {
  final String title;
  final String value;
  const KeyValTitleMedium({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: HexColor('#777777'),
        ),
        TextWidget(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
