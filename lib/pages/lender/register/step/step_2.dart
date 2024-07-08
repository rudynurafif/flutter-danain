import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/verification_complete_page.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

class Step2RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step2RegisLender({super.key, required this.regisBloc});

  @override
  State<Step2RegisLender> createState() => _Step2RegisLenderState();
}

class _Step2RegisLenderState extends State<Step2RegisLender> {
  String? otpCode;
  bool otpValid = false;
  int _totalSeconds = 120;
  int _minutes = 2;
  int _seconds = 0;
  bool _timerEnded = false;

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
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

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
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
        widget.regisBloc.reqOtp();
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
        color: HexColor('#27AE60'),
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
    return WillPopScope(
      child: Scaffold(
        appBar: previousCustomWidget(context, () {
          widget.regisBloc.stepControl(1);
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
                subVerif(widget.regisBloc),
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
      ),
      onWillPop: () async {
        widget.regisBloc.stepControl(1);
        return false;
      },
    );
  }

  Widget subVerif(RegisterLenderBloc rgBloc) {
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
          text: ' ${rgBloc.phoneValue.value}',
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
    return StreamBuilder<bool?>(
      stream: widget.regisBloc.otpError,
      builder: (context, snapshot) {
        bool data = snapshot.data ?? false;
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: OtpTextField(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                numberOfFields: 6,
                focusedBorderColor: HexColor(lenderColor),
                enabledBorderColor:
                data == true  ? Colors.red : HexColor('#DFE8E1'),
                fieldWidth: MediaQuery.of(context).size.width / 8,
                borderColor: HexColor(lenderColor),
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
                  widget.regisBloc.otpControl(verificationCode);
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
            const SizedBox(height: 10),
            if (data == true)
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
    if(!isValid){
      widget.regisBloc.otpControlError(false);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Button1(
          btntext: 'Verifikasi',
          color: isValid ? HexColor(lenderColor) : Colors.grey,
          action: isValid
              ? () {
            widget.regisBloc.sendOtp();
                  // widget.regisBloc.stepControl(3);
                }
              : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
