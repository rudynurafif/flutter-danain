import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class Step7RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step7RegisLender({super.key, required this.regisBloc});

  @override
  State<Step7RegisLender> createState() => _Step7RegisLenderState();
}

class _Step7RegisLenderState extends State<Step7RegisLender> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        // Navigator.pop(context);
      }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 96),
            SvgPicture.asset('assets/images/forgot_password/send_gmail_lender.svg'),
            const SizedBox(height: 24),
            const Headline2(text: checkEmail),
            const SizedBox(height: 8),
            textSendEmail(context),
            const SizedBox(height: 54),
            buttonResend(context),
            const SizedBox(height: 16),
            changeEmail()
          ],
        ),
      ),
    );
  }

  Widget textSendEmail(BuildContext context) {
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
            text: widget.regisBloc.emailValue.hasValue
                ? widget.regisBloc.emailValue.value
                : 'No Email Available',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const TextSpan(
            text:
            '. Segera cek email dan klik tombol "Verifikasi Email" untuk melanjutkan proses pendaftaran.',
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
  }


  Widget buttonResend(BuildContext context) {
    return Button1(
      btntext: 'Kirim Ulang Verifikasi',
      action: () {
        widget.regisBloc.sendEmail();
      },
      color: HexColor(lenderColor),
    );
  }

  Widget changeEmail() {
    return InkWell(
      onTap: () {
        widget.regisBloc.stepControl(8);
        widget.regisBloc.errorEmailControl('');
        widget.regisBloc.emailValue.add('');
      },
      child: Headline3(
        text: 'Ubah Alamat Email',
        color: HexColor(lenderColor),
        align: TextAlign.center,
      ),
    );
  }
}
