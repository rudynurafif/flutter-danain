import 'package:flutter/material.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_bloc.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Step1UbahEmail extends StatefulWidget {
  final UbahEmailBloc ubahBloc;
  const Step1UbahEmail({super.key, required this.ubahBloc});

  @override
  State<Step1UbahEmail> createState() => _Step1UbahEmailState();
}

class _Step1UbahEmailState extends State<Step1UbahEmail> {
  @override
  Widget build(BuildContext context) {
    final emailBloc = widget.ubahBloc;
    return StreamBuilder<Result<AuthenticationState>?>(
      stream: emailBloc.authState,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: previousWidget(context),
            body: snapshot.data?.fold(
              ifLeft: (value) {
                return bodyError();
              },
              ifRight: (value) {
                return bodyBuilder(value.userAndToken!);
              },
            ),
          );
        } else {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget bodyError() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: const Subtitle1(text: 'Maaf sepertinya terjadi kesalahan'),
    );
  }

  Widget bodyBuilder(UserAndToken data) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 97),
          SvgPicture.asset('assets/images/forgot_password/send_email.svg'),
          const SizedBox(height: 24),
          const Headline2(text: 'Kirim Kode Verifikasi'),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text:
                      'Untuk melindungi keamanan akun Anda. Kami akan mengirimkan kode verifikasi perubahan email ke nomor ',
                  style: TextStyle(
                    color: Color(0xff777777),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: data.user.tlpmobile,
                  style: const TextStyle(
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
              widget.ubahBloc.reqOtp('request');
            },
          )
        ],
      ),
    );
  }
}
