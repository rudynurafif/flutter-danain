import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/ubah_hp_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Step1VerifHp extends StatefulWidget {
  final UbahHpBloc hpBloc;
  final String hisEmail;
  const Step1VerifHp({super.key, required this.hpBloc, required this.hisEmail});

  @override
  State<Step1VerifHp> createState() => _Step1VerifHpState();
}

class _Step1VerifHpState extends State<Step1VerifHp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousWidget(context),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 97),
            SvgPicture.asset('assets/images/register/change_email.svg'),
            const SizedBox(height: 24),
            const Headline2(text: 'Kirim Email Verifikasi'),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text:
                        'Untuk melindungi keamanan akun Anda. Kami akan mengirimkan link verifikasi perubahan nomor handphone ke email ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff777777),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: hashEmail(widget.hisEmail),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0XFF333333),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Button1(
              btntext: 'Kirim',
              action: () {
                widget.hpBloc.sendEmail(2);
              },
            )
          ],
        ),
      ),
    );
  }
}
