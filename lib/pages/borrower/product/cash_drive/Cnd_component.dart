import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class LihatDetailAgunanComponent extends StatelessWidget {
  final String idTask;
  final num jumlahPinjaman;
  final String status;
  final String alamatUtama;
  final String alamatDetail;
  final String tglSurvey;
  final VoidCallback onTap;
  final String merk;
  final String jenis;
  final String tipe;
  const LihatDetailAgunanComponent({
    super.key,
    required this.idTask,
    required this.jumlahPinjaman,
    required this.status,
    required this.alamatUtama,
    required this.alamatDetail,
    required this.tglSurvey,
    required this.onTap,
    required this.merk,
    required this.jenis,
    required this.tipe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color: HexColor('#EEEEEE'),
                ),
                color: HexColor('#FFFFFF'),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  jenis == 'Mobil'
                                      ? 'assets/images/icons/square_icCar.svg'
                                      : 'assets/images/icons/square_icMotor.svg',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                ),
                                const SpacerH(value: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Subtitle3(
                                      text: 'Pengajuan Pinjaman',
                                      color: Color(0xFFAAAAAA),
                                    ),
                                    const SpacerV(value: 6),
                                    Subtitle600(
                                      text: rupiahFormat(jumlahPinjaman),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SpacerV(value: 12),
                        const DividerWidget(height: 1),
                        const SpacerV(value: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8.0), // Adjust padding as needed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Subtitle3(
                                      text: 'Jenis',
                                      color: HexColor('#AAAAAA'),
                                    ),
                                    const SizedBox(height: 4),
                                    Subtitle2Extra(text: jenis)
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8.0), // Adjust padding as needed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Subtitle3(
                                      text: 'Merk',
                                      color: HexColor('#AAAAAA'),
                                    ),
                                    const SizedBox(height: 4),
                                    Subtitle2Extra(
                                      text: merk,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8.0), // Adjust padding as needed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Subtitle3(
                                      text: 'Tipe',
                                      color: HexColor('#AAAAAA'),
                                    ),
                                    const SizedBox(height: 4),
                                    Subtitle2Extra(
                                      text: tipe,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpacerV(value: 8),
                        const DividerWidget(height: 1),
                        const SpacerV(value: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Headline4500(
                              text: 'Lihat Detail Agunan >',
                              color: HexColor(borrowerColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
    );
  }
}

class KontakComponent extends StatelessWidget {
  final String nasabahUtama;
  final String kontakUtama;
  const KontakComponent({
    super.key,
    required this.nasabahUtama,
    required this.kontakUtama,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Surveyor',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: HexColor('##AAAAAA'),
          ),
          const SpacerV(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/lender/profile/icon_user_borrower.svg',
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                  const SpacerH(value: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: nasabahUtama,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      const SpacerV(value: 4),
                      TextWidget(
                        text: kontakUtama,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7E7E7E),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  launch('tel://$kontakUtama');
                },
                child: SvgPicture.asset(
                  'assets/images/icons/icCall.svg',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LokasiComponent extends StatelessWidget {
  final String alamatUtama;
  final String alamatDetail;
  final String tanggalSurvey;
  final String maps;
  const LokasiComponent({
    super.key,
    required this.alamatUtama,
    required this.alamatDetail,
    required this.tanggalSurvey,
    required this.maps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: HexColor(borrowerColor),
              ),
              const SpacerH(),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: alamatUtama,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    const SpacerV(value: 6),
                    TextWidget(
                      text: alamatDetail,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff7E7E7E),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SpacerV(value: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: HexColor(borrowerColor),
              ),
              const SpacerH(),
              TextWidget(
                text: formatDateFullWithHour(tanggalSurvey),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PinjamanComponent extends StatelessWidget {
  final num pengajuan;
  final String jenis;
  final String merk;
  final String tipe;
  final String model;
  final String plat;
  final String tahun;
  final String cc;
  final String noStnk;
  final String noBpkb;
  final num jenisKendaraan;
  const PinjamanComponent({
    super.key,
    required this.pengajuan,
    required this.jenis,
    required this.merk,
    required this.tipe,
    required this.plat,
    required this.model,
    required this.tahun,
    required this.cc,
    required this.noStnk,
    required this.noBpkb,
    required this.jenisKendaraan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: HexColor('#EEEEEE'),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                jenisKendaraan == 1
                    ? 'assets/images/icons/square_icCar.svg'
                    : 'assets/images/icons/square_icMotor.svg',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SpacerH(value: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Pengajuan Pinjaman',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#AAAAAA'),
                  ),
                  const SpacerV(value: 2),
                  TextWidget(
                    text: rupiahFormat(pengajuan),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              )
            ],
          ),
          const SpacerV(value: 8),
          const DividerWidget(height: 1),
          const SpacerV(value: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                child: KeyValVertical(
                  title: 'Jenis',
                  value: shortenTextCustom(jenis, 10),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.6,
                child: KeyValVertical(
                  title: 'Merek',
                  value: shortenTextCustom(merk, 10),
                ),
              ),
              Flexible(
                child: KeyValVertical(
                  title: 'Tipe',
                  value: shortenTextCustom(tipe, 10),
                ),
              ),
            ],
          ),
          const SpacerV(value: 8),
          const DividerWidget(height: 1),
          const SpacerV(value: 8),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ModaLBottomTemplate(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpacerV(value: 24),
                        const TextWidget(
                          text: 'Detail Agunan',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SpacerV(value: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              jenis == 'Mobil'
                                  ? 'assets/images/icons/square_icCar.svg'
                                  : 'assets/images/icons/square_icMotor.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            const SpacerH(value: 16),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: '$merk - $tipe',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SpacerV(value: 4),
                                  TextWidget(
                                    text: model,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: HexColor('#777777'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SpacerV(value: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KeyValVertical(
                                    title: 'Jenis Kendaraan',
                                    value: jenis,
                                  ),
                                  const SpacerV(value: 12),
                                  KeyValVertical(
                                    title: 'Tahun Produksi',
                                    value: tahun,
                                  ),
                                  const SpacerV(value: 12),
                                  KeyValVertical(
                                    title: 'CC Kendaraan',
                                    value: cc,
                                  ),
                                ],
                              ),
                            ),
                            const SpacerH(value: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KeyValVertical(
                                    title: 'Nomor Polisi',
                                    value: plat,
                                  ),
                                  const SpacerV(value: 12),
                                  KeyValVertical(
                                    title: 'Nomor STNK',
                                    value: noStnk,
                                  ),
                                  const SpacerV(value: 12),
                                  KeyValVertical(
                                    title: 'Nomor BPKB',
                                    value: noBpkb,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: TextWidget(
              text: 'Lihat Detail Agunan >',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: HexColor('#288C50'),
            ),
          ),
        ],
      ),
    );
  }
}

class SuratComponent extends StatelessWidget {
  final String text;
  const SuratComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: HexColor('#F5F9F6'),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: HexColor('#51BD7E'),
            size: 16,
          ),
          const SpacerH(),
          TextWidget(
            text: text,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }
}
