import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../data/constants.dart';
import '../../../../../widgets/divider/divider.dart';
import '../../../../../widgets/rupiah_format.dart';
import '../../../../../widgets/text/text_widget.dart';
import 'row_data.dart';

class PotensiPendanaan extends StatelessWidget {
  final num jumlahPendanaan;
  final num bungaEfektif;
  final num bungaHutang;
  final num estimasiPengambalian;

  const PotensiPendanaan({
    super.key,
    required this.jumlahPendanaan,
    required this.bungaEfektif,
    required this.bungaHutang,
    required this.estimasiPengambalian,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text:
                'Akumulasi pengembalian dari jumlah pendanaan dan bunga efektif yang akan didapatkan',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 16),
          const TextWidget(
            text: 'Perhitungan Potensi Pendanaan',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          RowData(
            title: 'Jumlah Pendanaan',
            data: rupiahFormat(jumlahPendanaan),
            color: '#777777',
          ),
          const SizedBox(height: 8),
          RowData(
            title:
                'Bunga Efektif (${(bungaEfektif * 100).truncateToDouble() / 100}% p.a)',
            data: rupiahFormat(bungaHutang),
            color: '#777777',
          ),
          const SizedBox(height: 8),
          dividerDashed(context),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextWidget(
                text: 'Estimasi Pengembalian',
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              TextWidget(
                text: rupiahFormat(estimasiPengambalian),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: HexColor(lenderColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
