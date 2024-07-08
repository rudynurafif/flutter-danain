import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/index_step.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/Cnd_component.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class KonfirmasiPenyerahanBpkbPage extends StatelessWidget {
  static const routeName = '/konfirmasi_penyerahan_bpkb_page';
  const KonfirmasiPenyerahanBpkbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitleCustom(context, 'Detail Konfirmasi', () {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Headline3(text: 'Konfirmasi Jadwal Survey'),
            ),
            const SpacerV(value: 16),
            const KontakComponent(
              nasabahUtama: "Alexander Fernando",
              kontakUtama: "081234567890",
            ),
            const SpacerV(value: 16),
            const LokasiComponent(
              alamatUtama:
                  "Bendungan Jago No 28 RT19/RW03, Serdang, Kemayoran, Jakarata Pusat",
              alamatDetail: "Dekat masjid, pagar warna hitam",
              tanggalSurvey: "2024-04-25T13:34:23+07:00",
              maps: "",
            ),
            const SpacerV(value: 16),
            annoutcementNotice(context)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Konfirmasi',
          action: () {
            Navigator.pushNamed(context, IndexStepPage.routeName);
          },
        ),
      ),
    );
  }
}

Widget annoutcementNotice(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: HexColor('#FFF5F2'),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        width: 1,
        color: HexColor('FDE8CF'),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, size: 16, color: HexColor('#FF8829')),
        const SizedBox(width: 8),
        const Flexible(
          child: Subtitle3(
            text:
                'Pastikan Anda berada di lokasi sesuai dengan jadwal yang telah ditentukan ',
            color: Color(0xff5F5F5F),
            align: TextAlign.start,
          ),
        )
      ],
    ),
  );
}
