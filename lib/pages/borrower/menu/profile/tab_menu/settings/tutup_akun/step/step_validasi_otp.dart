import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/tutup_akun_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/verification_complete_page.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPenutupanAkun extends StatefulWidget {
  final TutupAkunBloc bloc;
  const OtpPenutupanAkun({super.key, required this.bloc});

  @override
  State<OtpPenutupanAkun> createState() => _OtpPenutupanAkunState();
}

class _OtpPenutupanAkunState extends State<OtpPenutupanAkun> {
  String? otpCode;
  bool otpValid = false;
  int _totalSeconds = 120;
  int _minutes = 2;
  int _seconds = 0;
  bool _timerEnded = false;

  String nomorAnda = 'nomor anda';

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_totalSeconds > 0) {
        setState(() {
          _totalSeconds--;
          _minutes = _totalSeconds ~/ 60;
          _seconds = _totalSeconds % 60;
        });
        startTimer();
      } else {
        setState(() {
          _timerEnded = true;
        });
      }
    });
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) => ModalPopUp(
        icon: 'assets/images/icons/check.svg',
        title: 'Verifikasi Data Diri',
        message:
            'Untuk tahap verifikasi, kami akan mengirimkan data pribadi Anda ke badan verifikasi sesuai dengan ketentuan perundang-undangan.',
        actions: [
          Button2(
            btntext: 'Kirim',
            action: () {
              Navigator.pushNamed(context, VerificationCompletePage.routeName);
            },
          )
        ],
      ),
    );
  }

  void setNomorTelepon() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('tlp_mobile') != null) {
      setState(() {
        nomorAnda = prefs.getString('tlp_mobile')!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    setNomorTelepon();
  }

  Widget resendOtp(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubtitleExtra(
            text: 'Jika tidak menerima pesan, silakan',
            color: HexColor('#777777'),
          ),
          _timerEnded ? timerEnd(context) : timerNotEnd(context)
        ],
      ),
    );
  }

  Widget timerEnd(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.bloc.postToOtp();
        setState(() {
          _totalSeconds = 120;
          _minutes = 2;
          _seconds = 0;
          _timerEnded = false;
          startTimer();
        });
      },
      child: Headline3500(
        text: 'Kirim Ulang',
        color: HexColor(primaryColorHex),
      ),
    );
  }

  Widget timerNotEnd(BuildContext context) {
    return SubtitleExtra(
      text:
          'kirim ulang dalam $_minutes:${_seconds.toString().padLeft(2, '0')}',
      color: HexColor('#777777'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        widget.bloc.stepController.sink.add(2);
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline1(text: 'Verifikasi OTP'),
              const SizedBox(height: 8),
              subVerif(widget.bloc),
              const SizedBox(height: 40),
              otpText(context),
              const SizedBox(height: 24),
              resendOtp(context),
              const SizedBox(height: 56),
              actionButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget subVerif(TutupAkunBloc bloc) {
    return Text.rich(
      TextSpan(children: <TextSpan>[
        const TextSpan(
          text: 'Silahkan masukkan 6 digit OTP yang dikirim ke ',
          style: TextStyle(
            color: Color(0xff777777),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: nomorAnda,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
      textAlign: TextAlign.start,
    );
  }

  Widget otpText(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bloc.otpStatusStream,
      builder: (context, snapshot) {
        bool data = snapshot.data ?? true;
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: OtpTextField(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                numberOfFields: 6,
                enabledBorderColor:
                    data == false ? Colors.red : HexColor(primaryColorHex),
                fieldWidth: MediaQuery.of(context).size.width / 8,
                borderColor: HexColor(primaryColorHex),
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                showFieldAsBox: true,
                borderWidth: 1,
                onCodeChanged: (code) {
                  setState(() {
                    otpCode = code;
                  });
                },
                onSubmit: (verificationCode) {
                  setState(() {
                    otpCode = verificationCode;
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 3),
            if (data == false)
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Subtitle2(
                    text: 'Kode OTP yang dimasukkan tidak sesuai',
                    color: Colors.red,
                  ),
                ],
              )
          ],
        );
      },
    );
  }

  Widget actionButton(BuildContext context) {
    bool isValid = otpCode?.length == 6;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Button1(
          btntext: 'Verifikasi',
          color: isValid ? null : Colors.grey,
          action: isValid
              ? () {
                  widget.bloc.validateOtp(otpCode!);
                }
              : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
