import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_bloc2.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

class KonfirmasiOtpPrivyPinjaman extends StatefulWidget {
  final KonfirmasiPinjamanBloc2 ppBloc;
  const KonfirmasiOtpPrivyPinjaman({super.key, required this.ppBloc});

  @override
  State<KonfirmasiOtpPrivyPinjaman> createState() => _OtpPrivyPinjamanState();
}

class _OtpPrivyPinjamanState extends State<KonfirmasiOtpPrivyPinjaman> {
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
    widget.ppBloc.otpControlError('');
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    startTimer();
  }

  Widget resendOtp(BuildContext context) {
    print("check timer $_timerEnded");
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
    print("check timer 1 $_timerEnded");
    return TextButton(
      onPressed: () {
        widget.ppBloc.konfirmasiPinjaman();

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
    print("check timer2$_timerEnded");
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
        widget.ppBloc.stepControl(1);
        widget.ppBloc.otpControlError('');
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
              subVerif(widget.ppBloc),
              const SizedBox(height: 40),
              otpText(widget.ppBloc),
              const SizedBox(height: 24),
              resendOtp(context),
              const SizedBox(height: 56),
              actionButton(widget.ppBloc)
            ],
          ),
        ),
      ),
    );
  }

  Widget subVerif(KonfirmasiPinjamanBloc2 bloc) {
    return StreamBuilder<String>(
      stream: bloc.noHpStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 'No hp Anda';
        return Text.rich(
          TextSpan(children: <TextSpan>[
            const TextSpan(
              text: 'Silahkan masukkan 5 digit OTP yang dikirim oleh privy ke ',
              style: TextStyle(
                color: Color(0xff777777),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: data,
              style: const TextStyle(
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

  Widget otpText(KonfirmasiPinjamanBloc2 bloc) {
    return StreamBuilder<String?>(
      stream: widget.ppBloc.otpError,
      builder: (context, snapshot) {
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: OtpTextField(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                numberOfFields: 5,
                focusedBorderColor: HexColor(primaryColorHex),
                enabledBorderColor: snapshot.hasData && snapshot.data != ''
                    ? Colors.red
                    : HexColor('#E9F6EB'),
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
                  bloc.otpControlError("");
                  setState(() {
                    otpCode = code;
                  });
                },
                onSubmit: (verificationCode) {
                  setState(() {
                    otpCode = verificationCode;
                  });
                  bloc.otpControl(verificationCode);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 3),
            if (snapshot.hasData && snapshot.data != '')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Subtitle2(
                    text: snapshot.data!,
                    color: Colors.red,
                  ),
                ],
              )
          ],
        );
      },
    );
  }

  Widget actionButton(KonfirmasiPinjamanBloc2 bloc) {
    bool isValid = otpCode?.length == 5;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Button1(
          btntext: 'Verifikasi',
          color: isValid ? null : Colors.grey,
          action: isValid
              ? () {
                  // bloc.stepControl(3);
                  bloc.postValidasiOtp();
                }
              : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
