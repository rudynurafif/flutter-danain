import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class VerificationCompletePage extends StatelessWidget {
  static const routeName = '/verif_complete';
  const VerificationCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth,
                  child: SvgPicture.asset(
                    'assets/images/verification/verification.svg',
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Headline2(
                  text: 'Dokumen Anda Sedang dalam Verifikasi',
                  align: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Subtitle2(
                  text:
                      'Data Anda sedang dalam verifikasi. Proses verifikasi maksimal 1 hari kerja',
                  align: TextAlign.center,
                  color: HexColor('#777777'),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Kembali ke Manu Utama',
          action: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.routeName,
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
