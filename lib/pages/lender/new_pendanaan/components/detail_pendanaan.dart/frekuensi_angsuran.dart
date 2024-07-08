import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/rupiah_format.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../widgets/divider/divider.dart';
import '../../../../../widgets/text/text_widget.dart';

class FrekuensiAngsuran extends StatelessWidget {
  final List<dynamic> listAngsuran;
  final String keyAngsuran;
  final String keyKeterangan;
  final String keyNominal;
  final String keyPokokHutang;
  const FrekuensiAngsuran({
    super.key,
    required this.listAngsuran,
    required this.keyAngsuran,
    required this.keyKeterangan,
    required this.keyNominal,
    required this.keyPokokHutang,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        bottom: 16,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpacerV(value: 24),
          const TextWidget(
            text: 'Frekuensi Angsuran',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              listAngsuran.length,
              (index) {
                final angsuranIndex = index + 1;
                final data = listAngsuran[index];
                final num pokokHutang = data[keyPokokHutang] ?? 0;
                final num bunga = data[keyNominal] ?? 0;
                final bool isLast = angsuranIndex == listAngsuran.length;
                final num akhir = pokokHutang + bunga;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Angsuran ke-${data[keyAngsuran]}',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: HexColor('#777777'),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: isLast ? 'Pendanaan+Bunga' : 'Bunga',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: HexColor('#333333'),
                        ),
                        TextWidget(
                          text: rupiahFormat(
                            isLast ? akhir : bunga,
                          ),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    angsuranIndex == listAngsuran.length
                        ? const SizedBox.shrink()
                        : dividerFullNoPadding(context),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
