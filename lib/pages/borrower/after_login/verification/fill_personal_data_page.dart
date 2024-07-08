import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/index_step.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class FillPersonalDataPage extends StatelessWidget {
  static const routeName = '/fill_personal_data';
  const FillPersonalDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitleCustom(context, 'Pengisian Data', () {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      }),
      body: Container(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageFillData(context),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Headline2(
                text: 'Pengisian Data Diri',
                align: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Subtitle2(
                text:
                    'Sebelum mulai, siapkan KTP dan pastikan koneksi internet dalam kondisi stabil',
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Mulai',
          action: () {
            Navigator.pushNamed(context, IndexStepPage.routeName);
          },
        ),
      ),
    );
  }
}

Widget imageFillData(BuildContext context) {
  return LayoutBuilder(
    builder: (context, BoxConstraints constraints) {
      return Container(
        width: constraints.maxWidth,
        child: SvgPicture.asset(
          'assets/images/verification/fill_personal_data.svg',
          fit: BoxFit.fitWidth,
        ),
      );
    },
  );
}
