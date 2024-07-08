import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

class OtpWidget extends StatefulWidget {
  final String appbarTitle;
  final String noTelp;
  final int digit;
  final Function1<String?, void> onChangeOtp;
  final Function1<String, void> onCompleteOtp;
  final VoidCallback postClick;
  final Function0<void> resend;
  final VoidCallback backAction;
  final String? errorText;
  final bool isLoadingButton;
  const OtpWidget({
    super.key,
    required this.appbarTitle,
    required this.noTelp,
    required this.digit,
    required this.onChangeOtp,
    required this.onCompleteOtp,
    required this.postClick,
    required this.resend,
    required this.backAction,
    required this.isLoadingButton,
    this.errorText,
  });

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  String? otpCode;
  bool otpValid = false;
  int _totalSeconds = 120;
  int _minutes = 2;
  int _seconds = 0;
  bool _timerEnded = false;

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
        widget.resend();
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
        color: HexColor(lenderColor),
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
      appBar: previousTitleCustom(
        context,
        widget.appbarTitle,
        widget.backAction,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline1(text: 'Verifikasi OTP'),
              const SizedBox(height: 8),
              subVerif(),
              const SizedBox(height: 40),
              otpText(),
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

  Widget subVerif() {
    return Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
          text: 'Silahkan masukkan ${widget.digit} digit OTP yang dikirim ke ',
          style: const TextStyle(
            color: Color(0xff777777),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: widget.noTelp,
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

  Widget otpText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: OtpTextField(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            numberOfFields: widget.digit,
            enabledBorderColor: widget.errorText != null
                ? HexColor('#EB5757')
                : HexColor(lenderColor),
            fieldWidth: MediaQuery.of(context).size.width / 8,
            borderColor: HexColor(lenderColor),
            enabled: true,
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
              widget.onChangeOtp(null);
            },
            onSubmit: (verificationCode) {
              setState(() {
                otpCode = verificationCode;
              });
              widget.onCompleteOtp(verificationCode);
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 3),
        if (widget.errorText != null)
          Subtitle2(
            text: widget.errorText!,
            color: HexColor('#EB5757'),
            align: TextAlign.end,
          )
      ],
    );
  }

  Widget actionButton(BuildContext context) {
    bool isValid = otpCode?.length == widget.digit;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.isLoadingButton == true
            ? const ButtonLoading()
            : Button1(
                btntext: 'Verifikasi',
                color: isValid ? HexColor(lenderColor) : Colors.grey,
                action: isValid ? widget.postClick : null,
              ),
        const SizedBox(height: 20),
      ],
    );
  }
}
