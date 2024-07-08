import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../data/constants.dart';
import '../../pages/borrower/after_login/complete_data/complete_data_page.dart';
import '../../pages/borrower/after_login/verification/fill_personal_data_page.dart';
import '../../widgets/text/subtitle.dart';

class NextStepControl extends StatelessWidget {
  final Map<String, dynamic> data;

  const NextStepControl({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final int status = data['status']['aktivasi_status'];
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }
    if (status == 10) {
      return const SizedBox.shrink();
    } else if (status == 0) {
      return verifikasiAkun(context);
    } else if (status == 10) {
      return aktivasiAkun(context);
    } else {
      return const SizedBox.shrink();
    }
  }
}

Widget verifikasiAkun(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
        borderRadius: BorderRadius.circular(4),
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x0C000000),
          blurRadius: 10,
          spreadRadius: 0,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle2Extra(text: 'Lengkapi Data Diri'),
              const SizedBox(height: 4),
              Subtitle5(
                text: 'Lengkapi data diri Anda untuk proses verifikasi data di Danain',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, FillPersonalDataPage.routeName);
                },
                child: Subtitle4Extra(
                  text: 'Lengkapi Sekarang >',
                  color: HexColor(primaryColorHex),
                ),
              )
            ],
          ),
        ),
        SvgPicture.asset('assets/images/verification/verif_logo.svg'),
      ],
    ),
  );
}

Widget aktivasiAkun(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
        borderRadius: BorderRadius.circular(4),
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x0C000000),
          blurRadius: 10,
          spreadRadius: 0,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle2Extra(text: 'Aktivasi Akun'),
              const SizedBox(height: 4),
              Subtitle5(
                text: 'Lengkapi data pendukung untuk aktivasi akun dan menikmati layanan Danain',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CompleteDataPage.routeName);
                },
                child: Subtitle4Extra(
                  text: 'Lengkapi Sekarang >',
                  color: HexColor(primaryColorHex),
                ),
              )
            ],
          ),
        ),
        SvgPicture.asset('assets/images/home/aktifasi_akun.svg'),
      ],
    ),
  );
}
