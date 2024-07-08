import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../../../../widgets/widget_element.dart';

class Step2UpdateHp extends StatefulWidget {
  final UpdateHpBloc hpBloc;
  const Step2UpdateHp({super.key, required this.hpBloc});

  @override
  State<Step2UpdateHp> createState() => _Step2UpdateHpState();
}

class _Step2UpdateHpState extends State<Step2UpdateHp> {
  String? otpCode;
  bool otpValid = false;
  int _totalSeconds = 120;
  int _minutes = 2;
  int _seconds = 0;
  bool _timerEnded = false;

  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    startTimer();
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
    final bloc = widget.hpBloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () => bloc.stepControl(1)),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline1(text: 'Verifikasi OTP'),
            const SizedBox(height: 8),
            subVerif(bloc),
            const SizedBox(height: 40),
            otpText(context),
            const SizedBox(height: 24),
            resendOtp(context),
            const SizedBox(height: 56),
            actionButton(context, bloc)
          ],
        ),
      ),
    );
  }

  Widget subVerif(UpdateHpBloc bloc) {
    return StreamBuilder(
      stream: bloc.authState,
      builder: (context, snapshot) {
        String hp = 'Nomor hp anda';
        if (snapshot.hasData) {
          snapshot.data!.map((value) {
            hp = value.userAndToken!.user.tlpmobile;
          });
        }
        return Text.rich(
          TextSpan(children: <TextSpan>[
            const TextSpan(
              text: 'Silahkan masukkan 6 digit OTP yang dikirim ke ',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff777777),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: hp,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
          textAlign: TextAlign.start,
        );
      },
    );
  }

  Widget otpText(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: OtpTextField(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            numberOfFields: 6,
            enabledBorderColor: HexColor(primaryColorHex),
            fieldWidth: MediaQuery.of(context).size.width / 8,
            borderColor: HexColor(primaryColorHex),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
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
              widget.hpBloc.otpControl(otpCode!);
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
        const SizedBox(height: 4),
      ],
    );
  }

  Widget actionButton(BuildContext context, UpdateHpBloc bloc) {
    bool isValid = otpCode?.length == 6;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Button1(
          btntext: 'Verifikasi',
          color: isValid ? null : Colors.grey,
          action: isValid ? () {
             bloc.submitOtp();
          } : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
