import 'package:flutter/material.dart';
import 'package:flutter_danain/utils/string_format.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';

class SkemaPendanaanWidget extends StatelessWidget {
  final String angsuranPokok;
  final String angsuranBunga;
  final String tanggalMulai;
  final String tanggalJatuhTempo;
  final String tglLunas;
  final int telatBayar;
  final bool isDetail;
  const SkemaPendanaanWidget({
    super.key,
    required this.angsuranPokok,
    required this.angsuranBunga,
    this.tanggalMulai = '0001-01-01T00:00:00Z',
    this.tanggalJatuhTempo = '0001-01-01T00:00:00Z',
    this.tglLunas = '0001-01-01T00:00:00Z',
    this.telatBayar = 0,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: HexColor('#EEEEEE'),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'Skema Pendanaan',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          TextWidget(
            text: 'Frekuensi pembayaran angsuran pokok dan bunga :',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: detailDataPendanaanLender(
                  'Angsuran Pokok',
                  angsuranPokok,
                ),
              ),
              detailDataPendanaanLender(
                'Angsuran Bunga',
                angsuranBunga,
              ),
            ],
          ),
          detailWidget(context),
        ],
      ),
    );
  }

  Widget detailWidget(BuildContext context) {
    if (isDetail) {
      return Column(
        children: [
          const SpacerV(value: 12),
          const DividerWidget(height: 1),
          const SpacerV(value: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: detailDataPendanaanLender(
                  'Tanggal Mulai',
                  dateFormat(tanggalMulai),
                ),
              ),
              SizedBox(
                width: 120,
                child: detailDataPendanaanLender(
                  'Jatuh Tempo',
                  dateFormat(tanggalJatuhTempo),
                ),
              ),
              if (telatBayar != 0)
                Flexible(
                  child: detailDataPendanaanLender(
                    'Telat Bayar',
                    '$telatBayar Hari',
                  ),
                ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class SkemaPendanaanLoading extends StatelessWidget {
  const SkemaPendanaanLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: HexColor('#EEEEEE'),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'Skema Pendanaan',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          TextWidget(
            text: 'Frekuensi pembayaran angsuran pokok dan bunga :',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: ShimmerLong(height: 40, width: 95),
              ),
              SizedBox(
                width: 100,
                child: ShimmerLong(height: 40, width: 95),
              ),
              SizedBox(
                width: 100,
                child: SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
