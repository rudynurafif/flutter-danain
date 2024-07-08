import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/ubah_hp_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Step2VerifHp extends StatefulWidget {
  final UbahHpBloc hpBloc;
  const Step2VerifHp({super.key, required this.hpBloc});

  @override
  State<Step2VerifHp> createState() => _Step2VerifHpState();
}

class _Step2VerifHpState extends State<Step2VerifHp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousWidget(context),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 97),
            SvgPicture.asset('assets/images/forgot_password/send_email.svg'),
            const SizedBox(height: 24),
            const Headline2(text: 'Cek Email Anda'),
            const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'Link verifikasi telah dikirim ke email Anda. Cek email dan klik tombol ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff777777),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: '“Ubah Nomor Handphone” ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0XFF333333),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'untuk melanjutkan proses perubahan nomor handphone.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff777777),
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
              btntext: 'Kirim Ulang Verifikasi',
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
