import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../data/constants.dart';
import '../../../../../widgets/divider/divider.dart';
import '../../../../../widgets/text/text_widget.dart';

class ListScore extends StatelessWidget {
  final String score;
  final String rentang;

  const ListScore({
    super.key,
    required this.score,
    required this.rentang,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: HexColor(lenderColor),
                  ),
                  color: HexColor('#F1FCF4')),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: TextWidget(
                  text: score,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextWidget(text: rentang, fontSize: 14, fontWeight: FontWeight.w400),
          ],
        ),
        score == 'E'
            ? const SizedBox.shrink()
            : Column(
                children: [
                  const SizedBox(height: 8),
                  dividerFullNoPadding(context),
                  const SizedBox(height: 8),
                ],
              ),
      ],
    );
  }
}
