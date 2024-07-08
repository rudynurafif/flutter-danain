import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi.dart';
import 'package:flutter_danain/pages/borrower/after_login/case_privy_borrower/case_privy_borrower_upload.dart';
import 'package:flutter_danain/pages/borrower/after_login/complete_data/complete_data_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/fill_personal_data_page.dart';
import 'package:flutter_danain/pages/borrower/home/qrcode_pages.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/string_format.dart';

class DetailKonfirmasiJadwalSurveyComponent extends StatelessWidget {
  final String idTask;
  final num jumlahPinjaman;
  final String status;
  final String alamatUtama;
  final String alamatDetail;
  final String tglSurvey;
  final VoidCallback onTap;
  final int isStatus;
  final int jenisKendaraan;
  const DetailKonfirmasiJadwalSurveyComponent({
    super.key,
    required this.idTask,
    required this.jumlahPinjaman,
    required this.status,
    required this.alamatUtama,
    required this.alamatDetail,
    required this.tglSurvey,
    required this.onTap,
    required this.isStatus,
    required this.jenisKendaraan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Headline3(
                text: isStatus == 2
                    ? 'Konfirmasi Jadwal Survey'
                    : 'Menunggu Survey',
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: HexColor('#DAF1DE'),
                  ),
                  color: HexColor('#F9FFFA'),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: HexColor('#E9F6EB'),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Subtitle2Extra(text: 'Cash & Drive'),
                              ],
                            ),
                          ),
                          Subtitle2(
                            text: idTask,
                            color: HexColor('#777777'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Color(0xFF24663F),
                                      ),
                                      const SpacerH(
                                        value: 8,
                                      ),
                                      Container(
                                        width: 276,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Subtitle3(
                                              text: shortenStringDynamic(
                                                alamatUtama,
                                                40,
                                              ),
                                            ),
                                            const SpacerV(value: 6),
                                            Subtitle3(
                                              text: alamatDetail,
                                              color: const Color(0xff7E7E7E),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SpacerV(value: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Color(0xFF24663F),
                                      ),
                                      const SpacerH(
                                        value: 8,
                                      ),
                                      Subtitle3(
                                        text: formatDateFullWithHour(tglSurvey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Color(0xffAAAAAA),
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

class DetailProsesPengajuanComponent extends StatelessWidget {
  final String idTask;
  final num jumlahPinjaman;
  final String status;
  final String alamatUtama;
  final String alamatDetail;
  final String tglSurvey;
  final VoidCallback onTap;
  final int isStatus;
  final int jenisKendaraan;
  const DetailProsesPengajuanComponent({
    super.key,
    required this.idTask,
    required this.jumlahPinjaman,
    required this.status,
    required this.alamatUtama,
    required this.alamatDetail,
    required this.tglSurvey,
    required this.onTap,
    required this.isStatus,
    required this.jenisKendaraan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: HexColor('#DAF1DE'),
                  ),
                  color: HexColor('#F9FFFA'),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: HexColor('#E9F6EB'),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Subtitle2Extra(text: 'Cash & Drive'),
                              ],
                            ),
                          ),
                          Subtitle2(
                            text: idTask,
                            color: HexColor('#777777'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    jenisKendaraan == 1
                                        ? 'assets/images/icons/square_icCar.svg'
                                        : 'assets/images/icons/square_icMotor.svg',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  const SpacerH(value: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Subtitle3(
                                        text: 'Nilai Pinjaman',
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Color(0xFF24663F),
                                      ),
                                      const SpacerH(
                                        value: 8,
                                      ),
                                      Container(
                                        width: 285,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Subtitle2(
                                              text: shortenStringDynamic(
                                                alamatUtama,
                                                39,
                                              ),
                                            ),
                                            const SpacerV(value: 6),
                                            Subtitle2(
                                              text: alamatDetail,
                                              color: const Color(0xff7E7E7E),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SpacerV(value: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Color(0xFF24663F),
                                      ),
                                      const SpacerH(
                                        value: 8,
                                      ),
                                      Subtitle3(
                                        text: formatDateFullWithHour(tglSurvey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

class PengajuanPenyerahanBPKBComponent extends StatelessWidget {
  final num nilaiPinjaman;
  final String tipe;
  final String noPengajuan;
  final VoidCallback onTap;
  final int isPenyerahan;
  final int jenisKendaraan;
  const PengajuanPenyerahanBPKBComponent({
    super.key,
    required this.nilaiPinjaman,
    required this.tipe,
    required this.onTap,
    required this.isPenyerahan,
    required this.noPengajuan,
    required this.jenisKendaraan,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Headline3(
                    text: isPenyerahan == 1
                        ? 'Konfirmasi Penyerahan BPKB'
                        : 'Penyerahan BPKB'),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: HexColor('#DAF1DE'),
                  ),
                  color: HexColor('#F9FFFA'),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: HexColor('#E9F6EB'),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Subtitle2Extra(text: 'Cash & Drive'),
                              ],
                            ),
                          ),
                          Subtitle2(
                            text: noPengajuan,
                            color: HexColor('#777777'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                jenisKendaraan == 1
                                    ? 'assets/images/icons/square_icCar.svg'
                                    : 'assets/images/icons/square_icMotor.svg',
                                width: 40,
                                height: 40,
                              ),
                              const SpacerH(value: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextWidget(
                                    text: 'Nilai Pinjaman',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFAAAAAA),
                                  ),
                                  const SpacerV(value: 6),
                                  TextWidget(
                                    text: rupiahFormat(nilaiPinjaman),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SpacerV(value: 12),
                          const DividerWidget(height: 1),
                          const SpacerV(value: 12),
                          TextWidget(
                            text: tipe,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}

class PinjamanBPKBComponent extends StatelessWidget {
  final num nilaiPinjaman;
  final String tipe;
  final String noPenawaran;
  final VoidCallback onTap;
  final int jenisKendaraan;
  const PinjamanBPKBComponent({
    super.key,
    required this.nilaiPinjaman,
    required this.tipe,
    required this.noPenawaran,
    required this.jenisKendaraan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Headline3(text: 'Konfirmasi Pinjaman'),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: HexColor('#DAF1DE'),
                  ),
                  color: HexColor('#F9FFFA'),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: HexColor('#E9F6EB'),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Subtitle2Extra(text: 'Cash & Drive'),
                              ],
                            ),
                          ),
                          Subtitle2(
                            text: noPenawaran,
                            color: HexColor('#777777'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                jenisKendaraan == 1
                                    ? 'assets/images/icons/square_icCar.svg'
                                    : 'assets/images/icons/square_icMotor.svg',
                                width: 40,
                                height: 40,
                              ),
                              const SpacerH(value: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextWidget(
                                    text: 'Nilai Pinjaman',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFAAAAAA),
                                  ),
                                  const SpacerV(value: 6),
                                  TextWidget(
                                    text: rupiahFormat(nilaiPinjaman),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SpacerV(value: 12),
                          const DividerWidget(height: 1),
                          const SpacerV(value: 12),
                          TextWidget(
                            text: tipe,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}

Widget haventverifData(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: HexColor('#F9FFFA'),
        border: Border.all(width: 1, color: HexColor('#DAF1DE')),
        borderRadius: BorderRadius.circular(8)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/home/datadiri.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Verifikasi Data Diri'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Lengkapi data diri Anda untuk proses verifikasi data di Danain',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Button2(
          btntext: 'Lengkapi Data Diri',
          textcolor: HexColor('#24663F'),
          color: HexColor('#F9FFFA'),
          action: () {
            Navigator.pushNamed(context, FillPersonalDataPage.routeName);
          },
        )
      ],
    ),
  );
}

Widget haventverifDataLender(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: HexColor('#E8F7EE'),
        border: Border.all(width: 1, color: HexColor('#D3EFDE')),
        borderRadius: BorderRadius.circular(8)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/home/datadirilender.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Lengkapi Data Diri'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Lengkapi data diri Anda agar bisa mulai mendanai di Danain',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Button2(
          btntext: 'Lengkapi Data Diri',
          textcolor: HexColor('#FFFFFF'),
          color: HexColor(lenderColor),
          action: () {
            Navigator.pushNamed(context, VerifikasiPage.routeName);
          },
        )
      ],
    ),
  );
}

Widget rdlWidget(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: HexColor('#E8F7EE'),
        border: Border.all(width: 1, color: HexColor('#D3EFDE')),
        borderRadius: BorderRadius.circular(8)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/home/datadirilender.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Lengkapi Data Diri'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Lengkapi data diri Anda agar bisa mulai mendanai di Danain',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Button2(
          btntext: 'Lengkapi Data Diri',
          textcolor: HexColor('#FFFFFF'),
          color: HexColor(lenderColor),
          action: () {
            Navigator.pushNamed(context, RegisRdlPage.routeName);
          },
        )
      ],
    ),
  );
}

Widget waitingVerifDataLender(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: HexColor('#E8F7EE'),
      border: Border.all(width: 1, color: HexColor('#D3EFDE')),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/lender/verifikasi/confirmation.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Data Anda Sedang Dalam Verifikasi'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Data Anda sedang dalam verifikasi. Proses verifikasi maksimal 1x24 jam hari kerja',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget haveverifData(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: HexColor('#F9FFFA'),
      border: Border.all(width: 1, color: HexColor('#DAF1DE')),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/home/datadiri-verif.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Selamat, Akun Sudah Terverifikasi'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Satu langkah lagi untuk menikmati layanan Danain. Lengkapi data pendukung dan mulai pengalaman terbaik Anda',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Button2(
          btntext: 'Lengkapi Data Pendukung',
          textcolor: HexColor('#24663F'),
          color: HexColor('#F9FFFA'),
          action: () {
            Navigator.pushNamed(context, AktivasiPage.routeName);
          },
        )
      ],
    ),
  );
}

Widget havePengajuanPinjaman(BuildContext context, dataHome, User user) {
  final Map<String, dynamic> users = {
    'email': user.username,
    'ktp': user.ktp,
    // Add other properties as needed
  };
  final Map<String, dynamic> arguments = {
    'dataHome': dataHome,
    'user': users,
  };
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First child: Headline3 widget wrapped in Padding
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Headline3(text: 'Pengajuan Pinjaman'),
        ),

        // Second child: SizedBox for vertical spacing
        const SizedBox(height: 12),

        // Third child: Container with loan offer details
        Container(
          width: double.infinity, // Set a specific width or use double.infinity
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HexColor('#F9FFFA'),
            border: Border.all(width: 1, color: HexColor('#DAF1DE')),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subsection with Row and SvgPicture
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/images/home/datadiri-verif.svg'),
                  const SizedBox(width: 16),

                  // Flexible Column with Headline5 and Subtitle3
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Headline5(text: 'Pengajuan Pinjaman'),
                        const SizedBox(height: 4),
                        Subtitle3(
                          text:
                              'Datang ke mitra dan tunjukkan QR Code untuk melanjutkan transaksi pinjaman',
                          color: HexColor('#777777'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Button2 widget
              Button2(
                btntext: 'Tampilkan QR Code',
                textcolor: HexColor('#24663F'),
                color: HexColor('#F9FFFA'),
                action: () {
                  Navigator.pushNamed(context, QrcodePages.routeName,
                      arguments: arguments);
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget verifDataProgress(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: HexColor('#FDE8CF'),
        border: Border.all(width: 1, color: HexColor('#FDE8CF')),
        borderRadius: BorderRadius.circular(8)
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     HexColor('#F9FFFA'),
        //     HexColor('#DAF1DE'),
        //   ],
        // ),
        ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/images/home/datadiri-progress.svg'),
        const SizedBox(width: 8),
        Flexible(
          child: Subtitle3(
            text:
                'Akun Anda sedang dalam proses verifikasi. Proses ini membutuhkan waktu 1x24 jam pada hari kerja.',
            color: HexColor('#FF8829'),
          ),
        )
      ],
    ),
  );
}

Widget penawaranPinjaman(BuildContext context, Map<String, dynamic> dataHome) {
  final List<dynamic> items = dataHome['pengjuan_pinjaman']['data_jaminan'];
  print('data home $dataHome');
  Map<String, dynamic> object = {};
  // Map<String, List<Map<String, dynamic>>> groupedGramData = {};
  for (dynamic item in items) {
    object = item;
    // String namaMitra = item['nama_mitra'];
    // String gram = item['gram'];
    // String karat = item['karat'];
    // Perform actions with the properties as needed
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Headline3(text: 'Penawaran Pinjaman'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: HexColor('#DAF1DE'),
              ),
              color: HexColor('#F9FFFA'),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: HexColor('#E9F6EB'),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/home/maxi.svg'),
                            const SizedBox(width: 8),
                            Subtitle2Extra(
                                text: dataHome['pengjuan_pinjaman']
                                    ['nama_produk']),
                          ],
                        ),
                      ),
                      Subtitle2(
                        text: dataHome['pengjuan_pinjaman']['no_penawaran']
                            .toString(),
                        color: HexColor('#777777'),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle3(
                        text: 'Jumlah Pinjaman',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      Headline2(
                          text: rupiahFormat(
                              dataHome['pengjuan_pinjaman']['nilai_pinjaman'])),
                      const SizedBox(height: 21),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Subtitle3(
                                text: 'Nama Mitra',
                                color: HexColor('#AAAAAA'),
                              ),
                              const SizedBox(height: 4),
                              Subtitle2Extra(
                                  text: shortText(
                                      object['nama_mitra'].toString(), 16))
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Subtitle3(
                                text: 'Berat',
                                color: HexColor('#AAAAAA'),
                              ),
                              const SizedBox(height: 4),
                              Subtitle2Extra(
                                text: shortenText(items
                                    .map((val) => '${val['gram']}G')
                                    .join(',')),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Subtitle3(
                                text: 'Karat',
                                color: HexColor('#AAAAAA'),
                              ),
                              const SizedBox(height: 4),
                              Subtitle2Extra(
                                text: shortenText(items
                                    .map((val) => '${val['karat']}k')
                                    .join(',')),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Button2(
                        btntext: 'Pinjam',
                        action: () {
                          Navigator.pushNamed(
                              context, PenawaranPinjamanPage.routeName,
                              arguments: PenawaranPinjamanPage(
                                idjaminan: dataHome['pengjuan_pinjaman']
                                    ['id_jaminan'],
                                idproduk: dataHome['pengjuan_pinjaman']
                                    ['id_produk'],
                              ));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
  );
}

String shortText(String text, int maxLength) {
  if (text.length > maxLength) {
    return '${text.substring(0, maxLength)}...';
  }
  return text;
}

Widget privyRejected(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: HexColor('#FDEEEE'),
      border: Border.all(width: 1, color: HexColor('#FBDDDD')),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/icons/error_icon.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Pendaftaran Belum Berhasil'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Dokumen Anda saat ini belum berhasil diverifikasi. Silakan hubungi tim kami.',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ButtonCustomError(
          btntext: 'Hubungi CS Danain',
          textcolor: HexColor('#EB5757'),
          color: HexColor('#FBDDDD'),
          action: () async {
            final url = dotenv.env['CALL_CENTER'].toString();
            final uri =
                Uri.parse(url); // Convert the URL string to a Uri object
            if (await canLaunchUrl(uri)) {
              // Use canLaunchUrl
              await launch(uri
                  .toString()); // Use the Uri.toString() method to pass the Uri as a string
            } else {
              throw 'Could not launch $url';
            }
          },
        )
      ],
    ),
  );
}

Widget privyRejectedLender(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: HexColor('#FDEEEE'),
      border: Border.all(width: 1, color: HexColor('#FBDDDD')),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/icons/error_icon.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Registrasi Belum Berhasil'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Dokumen Anda saat ini belum berhasil diverifikasi. Silakan hubungi tim kami.',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ButtonCustomError(
          btntext: 'Hubungi CS Danain',
          textcolor: HexColor('#EB5757'),
          color: HexColor('#FBDDDD'),
          action: () async {
            final url = dotenv.env['CALL_CENTER'].toString();
            final uri =
                Uri.parse(url); // Convert the URL string to a Uri object
            if (await canLaunchUrl(uri)) {
              // Use canLaunchUrl
              await launch(uri
                  .toString()); // Use the Uri.toString() method to pass the Uri as a string
            } else {
              throw 'Could not launch $url';
            }
          },
        )
      ],
    ),
  );
}

Widget privyFixDocumentLender(
  BuildContext context,
  Map<String, dynamic> statusPrivy,
  List<dynamic> dataUpdate,
) {
  // final List<Map<String, String>> dataUpdate = statusPrivy['dataUpdate'];
  print('check status account $dataUpdate');
  List<dynamic> object = convertListToObject(dataUpdate);

  // Print the result
  print(object); // Output: {jenisFile: KTP}
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: HexColor('#E8F7EE'),
      border: Border.all(width: 1, color: HexColor('#DAF1DE')),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/icons/edit_icon_lender.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(
                      text: 'Data Anda Belum Berhasil Diverifikasi'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Anda perlu memperbaiki data untuk melanjutkan proses verifikasi.',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Button2(
          btntext: 'Perbarui Data',
          textcolor: HexColor('#FFFFFF'),
          color: HexColor(lenderColor),
          action: () {
            Navigator.pushNamed(
              context,
              CasePrivyBorrower.routeName,
              arguments: CasePrivyBorrower(
                caseCode: statusPrivy['code']['code'],
                dataUpdate: object,
              ),
            );
          },
        )
      ],
    ),
  );
}

Widget privyFixDocumentBorrower(
  BuildContext context,
  Map<String, dynamic> statusPrivy,
  List<dynamic> dataUpdate,
) {
  // final List<Map<String, String>> dataUpdate = statusPrivy['dataUpdate'];
  print('check status account $dataUpdate');
  List<dynamic> object = convertListToObject(dataUpdate);

  // Print the result
  print(object); // Output: {jenisFile: KTP}
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: HexColor('#F9FFFA'),
      border: Border.all(width: 1, color: HexColor('#DAF1DE')),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/icons/edit_icon.svg'),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Headline5(text: 'Pendaftaran Belum Berhasil'),
                  const SizedBox(height: 4),
                  Subtitle3(
                    text:
                        'Anda perlu memperbaiki data untuk melanjutkan proses verifikasi.',
                    color: HexColor('#777777'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Button2(
          btntext: 'Perbarui Data',
          textcolor: HexColor('#24663F'),
          color: HexColor('#F9FFFA'),
          action: () {
            Navigator.pushNamed(
              context,
              CasePrivyBorrower.routeName,
              arguments: CasePrivyBorrower(
                caseCode: statusPrivy['code'],
                dataUpdate: object,
              ),
            );
          },
        )
      ],
    ),
  );
}

List<dynamic> convertListToObject(List<dynamic> list) {
  // Initialize an empty object
  List<dynamic> result = [];

  // Iterate through the list and add each key-value pair to the object
  for (dynamic item in list) {
    print('check item $item');
    // if (item is Map<String, dynamic>) {
    //   result.addAll(item);
    String jenisFile = item['jenisFile'] ?? '';
    result.add(jenisFile);
    // }
  }

  return result;
}
