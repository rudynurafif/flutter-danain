import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousHelpCustome.dart';
import 'package:flutter_danain/pages/login/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class ExpiredScreen extends StatefulWidget {
  static const routeName = '/expired_screen';
  const ExpiredScreen({super.key});

  @override
  State<ExpiredScreen> createState() => _ExpiredScreenState();
}

class _ExpiredScreenState extends State<ExpiredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousHelpCustomeWidget(
        context,
        () => Navigator.pushNamed(context, LoginPage.routeName),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/register/expired.svg'),
            const SizedBox(height: 16),
            const Headline2(
              text: 'Link Sudah Tidak Aktif',
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Subtitle2(
              text:
                  'Gagal masuk ke halaman tujuan karena link sudah tidak aktif',
              align: TextAlign.center,
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 40),
            Button1(
              btntext: 'Kemabali ke Menu Utama',
              action: () {
                Navigator.pushNamed(context, LoginPage.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
