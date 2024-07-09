import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/components/detail_pendanaan.dart/modal_title.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:flutter_danain/component/home/verif_component.dart';
import 'detail_agunan.dart';

class AgunanWidget extends StatelessWidget {
  final String jenisKendaraan;
  final String merek;
  final String model;
  final String type;
  final String image;
  final String cc;
  final String tahunProduksi;
  final String namaKendaraan;
  final String kondisiKendaraan;
  final String keterangan;
  final String namaMitra;
  const AgunanWidget({
    super.key,
    required this.jenisKendaraan,
    required this.merek,
    required this.model,
    required this.type,
    required this.image,
    required this.cc,
    required this.tahunProduksi,
    required this.namaKendaraan,
    required this.kondisiKendaraan,
    required this.keterangan,
    required this.namaMitra,
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
            text: 'Agunan',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          TextWidget(
            text: 'Pendanaan dilengkapi dengan agunan Buku Pemilik Kendaraan Bermotor (BPKB).',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: detailDataPendanaanLender(
                  'Jenis',
                  shortText(jenisKendaraan, 10),
                ),
              ),
              SizedBox(
                width: 100,
                child: detailDataPendanaanLender(
                  'Merk',
                  shortText(merek, 10),
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 100,
                  child: detailDataPendanaanLender(
                    'Tipe',
                    shortText(type, 10),
                  ),
                ),
              ),
            ],
          ),
          const SpacerV(value: 8),
          const DividerWidget(height: 1),
          const SpacerV(value: 14),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                builder: (context) {
                  return IntrinsicHeight(
                    child: Column(
                      children: [
                        const ModalTitle(title: 'Detail Agunan'),
                        Expanded(
                          child: SingleChildScrollView(
                            child: DetailAgunan(
                              jenisKendaraan: jenisKendaraan,
                              merek: merek,
                              type: type,
                              model: model,
                              image: image,
                              cc: cc,
                              tahunProduksi: tahunProduksi,
                              namaKendaraan: namaKendaraan,
                              kondisiKendaraan: kondisiKendaraan,
                              keterangan: keterangan,
                              namaMitra: namaMitra,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Lihat selengkapnya',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: HexColor(lenderColor),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset('assets/lender/portofolio/chev_right.svg')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgunanLoading extends StatelessWidget {
  const AgunanLoading({super.key});

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
            text: 'Agunan',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          TextWidget(
            text: 'Pendanaan dilengkapi dengan agunan Buku Pemilik Kendaraan Bermotor (BPKB).',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 8),
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
                child: ShimmerLong(height: 40, width: 95),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
