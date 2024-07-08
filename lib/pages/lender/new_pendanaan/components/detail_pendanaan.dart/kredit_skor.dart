import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_danain/widgets/text/text_widget.dart';

class KreditSkor extends StatelessWidget {
  const KreditSkor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text:
                'Kredit skor diterapkan Danain untuk melihat kemampuan peminjam dalam melunasi pinjamannya. Semakin mendekati skor tertinggi di angka 200 semakin baik reputasi peminjam.',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: HexColor('#777777'),
          ),
          // const SizedBox(height: 16),
          // dividerFullNoPadding(context),
          // const SizedBox(height: 16),
          // const TextWidget(
          //   text: 'Kredit Skor',
          //   fontSize: 16,
          //   fontWeight: FontWeight.w500,
          // ),
          // const SizedBox(height: 16),
          // const ListScore(score: 'A', rentang: '191-200'),
          // const ListScore(score: 'B', rentang: '181-190'),
          // const ListScore(score: 'C', rentang: '171-180'),
          // const ListScore(score: 'D', rentang: '161-170'),
          // const ListScore(score: 'E', rentang: '≤160'),
        ],
      ),
    );
  }
}
