import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'frekuensi_angsuran.dart';
import 'modal_title.dart';
import 'potensi_pendanaan.dart';
import 'row_data.dart';

class JumlahPendanaan extends StatelessWidget {
  final num pokokHutang;
  final num potensiPendanaan;
  final num bungaEfektif;
  final num bungaHutang;
  final int tenor;
  final String tujuan;
  final List<dynamic> listAngsuran;
  final String keyAngsuran;
  final String keyKeterangan;
  final String keyNominal;
  final String keyPokokHutang;
  final bool isRiwayat;
  final VoidCallback onTapRiwayat;
  const JumlahPendanaan({
    super.key,
    required this.pokokHutang,
    required this.potensiPendanaan,
    required this.bungaEfektif,
    required this.tenor,
    required this.tujuan,
    required this.bungaHutang,
    required this.listAngsuran,
    required this.keyAngsuran,
    required this.keyKeterangan,
    required this.keyNominal,
    this.isRiwayat = false,
    required this.onTapRiwayat,
    required this.keyPokokHutang,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: isRiwayat
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )
                : BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: HexColor('#EEEEEE'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: 'Jumlah Pendanaan',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  TextWidget(
                    text: rupiahFormat(pokokHutang),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8))),
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ModalTitle(title: 'Potensi Pendanaan'),
                                PotensiPendanaan(
                                  jumlahPendanaan: pokokHutang,
                                  bungaEfektif: bungaEfektif,
                                  bungaHutang: bungaHutang,
                                  estimasiPengambalian: potensiPendanaan,
                                ),
                                const DividerGrey(),
                                Expanded(
                                  child: Scrollbar(
                                    thickness: 5,
                                    radius: const Radius.circular(16),
                                    child: SingleChildScrollView(
                                      child: FrekuensiAngsuran(
                                        listAngsuran: listAngsuran,
                                        keyAngsuran: keyAngsuran,
                                        keyKeterangan: keyKeterangan,
                                        keyNominal: keyNominal,
                                        keyPokokHutang: keyPokokHutang,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/lender/portofolio/arrow_top_right.svg',
                        ),
                        const SizedBox(width: 4),
                        Headline4500(
                          text: rupiahFormat(potensiPendanaan),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                            'assets/lender/portofolio/alert_fill.svg'),
                      ],
                    ),
                  ),
                ],
              ),
              dividerFull4(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: detailDataPendanaanLender(
                      'Bunga Efektif',
                      '${(bungaEfektif * 100).truncateToDouble() / 100} % p.a',
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: detailDataPendanaanLender(
                      'Tenor',
                      '$tenor Bulan',
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 100,
                      child: detailDataPendanaanLender(
                        'Tujuan',
                        tujuan,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        widgetRiwayat(context),
      ],
    );
  }

  Widget widgetRiwayat(BuildContext context) {
    if (isRiwayat) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTapRiwayat,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffF4FEF5),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border(
              left: BorderSide(width: 1, color: Color(0xffEEEEEE)),
              right: BorderSide(width: 1, color: Color(0xffEEEEEE)),
              bottom: BorderSide(width: 1, color: Color(0xffEEEEEE)),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: 'Riwayat Pembayaran',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff28AF60),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: Color(0xff28AF60),
                size: 18,
              )
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class JumlahPendanaanLoading extends StatelessWidget {
  const JumlahPendanaanLoading({super.key});

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
          TextWidget(
            text: 'Jumlah Pendanaan',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const ShimmerLong(height: 21, width: 110),
              const SizedBox(width: 8),
              SvgPicture.asset('assets/lender/portofolio/arrow_top_right.svg'),
              const SizedBox(width: 4),
              const ShimmerLong(height: 18, width: 94),
              const SizedBox(width: 8),
            ],
          ),
          dividerFull2(context),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: ShimmerLong(height: 40, width: 95),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
