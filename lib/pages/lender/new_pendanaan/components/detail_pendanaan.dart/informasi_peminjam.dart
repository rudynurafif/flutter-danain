import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import 'package:flutter_danain/utils/format_sensor_nama.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'kredit_skor.dart';
import 'modal_title.dart';

class InformasiPeminjamWidget extends StatelessWidget {
  final String namaBorrower;
  final num kreditSkor;
  const InformasiPeminjamWidget({
    super.key,
    required this.namaBorrower,
    required this.kreditSkor,
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
            text: 'Informasi Peminjam',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailDataPendanaanLender(
                      'Skor Kredit',
                      // '${kreditSkor.truncateToDouble()}',
                      '$kreditSkor',
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                          builder: (context) {
                            return const IntrinsicHeight(
                              child: Column(
                                children: [
                                  ModalTitle(title: 'Kredit Skor'),
                                  KreditSkor(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/lender/portofolio/alert_fill.svg',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: detailDataPendanaanLender(
                  'Nama',
                  formatSensorNama(namaBorrower),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InformasiPeminjamLoading extends StatelessWidget {
  const InformasiPeminjamLoading({super.key});

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Informasi Peminjam',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ShimmerLong(height: 40, width: 95),
                    ),
                  ],
                ),
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
          ),
        ],
      ),
    );
  }
}
