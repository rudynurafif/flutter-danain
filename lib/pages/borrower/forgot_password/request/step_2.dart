import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/request_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class Step2ForgotPassword extends StatefulWidget {
  final ForgotPasswordEmailBloc fpBloc;
  const Step2ForgotPassword({super.key, required this.fpBloc});

  @override
  State<Step2ForgotPassword> createState() => _Step2ForgotPasswordState();
}

class _Step2ForgotPasswordState extends State<Step2ForgotPassword> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
    final bloc = widget.fpBloc;
    return WillPopScope(
      onWillPop: () async {
        bloc.stepControl(1);
        return false;
      },
      child: Scaffold(
        appBar: previousCustomWidget(
          context,
          () {
            bloc.stepControl(1);
          },
        ),
          body: FutureBuilder<int?>(
            future: rxPrefs.getInt('user_status'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Handle the loading state if necessary.
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle the error state if necessary.
                return Text('Error: ${snapshot.error}');
              } else {
                int? data = snapshot.data;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(data == 2 ? 'assets/images/forgot_password/send_email.svg': 'assets/images/forgot_password/send_gmail_lender.svg'),
                      const SizedBox(height: 24),
                      const Headline2(text: checkEmail),
                      const SizedBox(height: 8),
                      textSendEmail(bloc),
                      const SizedBox(height: 54),
                      buttonResend(bloc, data)
                    ],
                  ),
                );
              }
            },
          )

      ),
    );
  }

  Widget textSendEmail(ForgotPasswordEmailBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, snapshot) {
        return Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: 'Link verifikasi telah dikirim ke ',
                style: TextStyle(
                  color: Color(0xff777777),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: snapshot.data,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              const TextSpan(
                text:
                    '. Segera cek email dan klik tombol “Ubah Kata Sandi” untuk melanjutkan proses pendaftaran.',
                style: TextStyle(
                  color: Color(0xff777777),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  Widget buttonResend(ForgotPasswordEmailBloc bloc, int? data) {
    if (data == 2 ){
      return Button1(
        btntext: 'Kirim Ulang Verifikasi',
        action: () {
          bloc.submit();
        },
      );
    }else{
      return Button1Lender(
        btntext: 'Kirim Ulang Verifikasi',
        action: () {
          bloc.submit();
        },
      );
    }

  }
}
