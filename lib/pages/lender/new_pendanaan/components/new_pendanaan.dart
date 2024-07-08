import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/portofolio_detail_page.dart';
import 'package:flutter_danain/utils/string_format.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/space_h.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import '../new_detail_pendanaan/new_detail_pendanaan_page.dart';
import '../../../../widgets/divider/divider.dart';
import '../../../../widgets/rupiah_format.dart';
import '../../../../widgets/text/text_widget.dart';

class NewPendanaanWidget extends StatelessWidget {
  final int idAgreement;
  final int idPendanaan;
  final String namaProduk;
  final String picture;
  final String noPerjanjianPinjaman;
  final String jenis;
  final String merek;
  final String tipe;
  final num jumlahPendanaan;
  final int tenor;
  final num bunga;
  final String skor;
  final bool isPemula;
  final double paddingB;

  const NewPendanaanWidget({
    super.key,
    required this.idAgreement,
    required this.idPendanaan,
    required this.namaProduk,
    required this.picture,
    required this.noPerjanjianPinjaman,
    this.jenis = '',
    this.merek = '',
    this.tipe = '',
    required this.jumlahPendanaan,
    required this.tenor,
    required this.bunga,
    this.skor = '',
    this.isPemula = false,
    this.paddingB = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          NewDetailPendanaanPage.routeName,
          arguments: idAgreement,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: paddingB),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: isPemula
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              picture,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const ShimmerLong(
                                  height: 40,
                                  width: 40,
                                  radius: 4,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: namaProduk,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 4),
                              TextWidget(
                                text: 'No. PP $noPerjanjianPinjaman',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: HexColor('#777777'),
                              )
                            ],
                          ),
                        ],
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: const BorderRadius.only(
                      //       topLeft: Radius.circular(8),
                      //       bottomLeft: Radius.circular(8),
                      //     ),
                      //     color: HexColor(lenderColor2),
                      //   ),
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 12,
                      //     vertical: 4,
                      //   ),
                      //   child: TextWidget(
                      //     text: skor,
                      //     fontSize: 14,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // )
                    ],
                  ),
                  dividerFull4(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: detailDataPendanaanLender(
                          'Jumlah Pendanaan',
                          rupiahFormat(jumlahPendanaan),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          // width: 90,
                          child: detailDataPendanaanLender(
                            'Tenor',
                            '$tenor bulan',
                          ),
                        ),
                      ),
                      const SpacerH(value: 10),
                      Flexible(
                        child: detailDataPendanaanLender(
                          'Bunga',
                          '$bunga% p.a',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isPemula)
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color: HexColor('#F5F9F6'),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/lender/portofolio/Like.svg'),
                      const SizedBox(width: 8),
                      const TextWidget(
                        text: 'Cocok untuk pemula',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PendanaanStatus extends StatelessWidget {
  final int idPendanaan;
  final String namaProduk;
  final String picture;
  final String noPerjanjianPinjaman;
  final num jumlahPendanaan;
  final num bunga;
  final double paddingB;
  final String status;
  final bool isLunas;
  final String date;
  const PendanaanStatus({
    super.key,
    required this.idPendanaan,
    required this.namaProduk,
    required this.picture,
    required this.noPerjanjianPinjaman,
    required this.jumlahPendanaan,
    required this.bunga,
    this.paddingB = 16,
    this.status = '',
    this.isLunas = false,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          PortofolioDetail.routeName,
          arguments: PortofolioDetail(idAgreement: idPendanaan),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: paddingB),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: HexColor('#EEEEEE'),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        picture,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const ShimmerLong(
                            height: 40,
                            width: 40,
                            radius: 4,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: namaProduk,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        TextWidget(
                          text: 'No. PP $noPerjanjianPinjaman',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: HexColor('#777777'),
                        )
                      ],
                    ),
                  ],
                ),
                statusBuilder(context),
              ],
            ),
            const SizedBox(height: 8),
            const DividerWidget(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: detailData(
                    'Jumlah Pendanaan',
                    rupiahFormat(jumlahPendanaan),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: detailData(
                    'Bunga',
                    formatBungaDanain(bunga),
                  ),
                ),
                detailData(
                  isLunas ? 'Tanggal Lunas' : 'Jatuh Tempo',
                  dateFormat(date),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget statusBuilder(BuildContext context) {
    if (status.toLowerCase() == 'aktif') {
      return statusTabContent(
        tabColor: HexColor('#F2F8FF'),
        title: 'Aktif',
        titleColor: HexColor('#007AFF'),
      );
    }
    if (status.toLowerCase() == 'terlambat') {
      return statusTabContent(
        tabColor: HexColor('#FEF4E8'),
        title: 'Telat Bayar',
        titleColor: HexColor('#F7951D'),
      );
    }
    if (status.toLowerCase() == 'lunas') {
      return statusTabContent(
        tabColor: HexColor('#F4FEF5'),
        title: 'Selesai',
        titleColor: HexColor('#28AF60'),
      );
    }
    return const SizedBox.shrink();
  }

  Widget statusTabContent({
    required Color tabColor,
    required String title,
    required Color titleColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: tabColor,
      ),
      alignment: Alignment.center,
      child: Subtitle3(
        text: title,
        color: titleColor,
      ),
    );
  }
}
