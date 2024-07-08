import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

Widget contentAngsuran(String titleContent, int harga, VoidCallback action) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubtitleExtra(text: titleContent),
          Headline3500(text: rupiahFormat(harga))
        ],
      ),
      GestureDetector(
        onTap: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle2(
              text: 'Lihat detail',
              color: HexColor(primaryColorHex),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_right,
              size: 15,
              color: HexColor(primaryColorHex),
            )
          ],
        ),
      )
    ],
  );
}

Widget angsuranLoading(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShimmerLong(height: 14, width: MediaQuery.of(context).size.width / 3),
          ShimmerLong(height: 14, width: MediaQuery.of(context).size.width / 3),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 14, width: MediaQuery.of(context).size.width / 3),
          const SizedBox(width: 4),
          const ShimmerCircle(height: 15, width: 15)
        ],
      ),
    ],
  );
}
