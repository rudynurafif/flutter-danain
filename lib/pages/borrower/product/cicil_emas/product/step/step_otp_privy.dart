import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

class OtpPrivyCicilan extends StatefulWidget {
  final CicilEmas2Bloc cBloc;
  const OtpPrivyCicilan({super.key, required this.cBloc});

  @override
  State<OtpPrivyCicilan> createState() => _OtpPrivyCicilanState();
}

class _OtpPrivyCicilanState extends State<OtpPrivyCicilan> {
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
        widget.cBloc.reqOtpClick();
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
    final bloc = widget.cBloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        bloc.stepChange(4);
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
              subVerif(bloc),
              const SizedBox(height: 40),
              otpText(bloc),
              const SizedBox(height: 24),
              resendOtp(context),
              const SizedBox(height: 56),
              actionButton(bloc)
            ],
          ),
        ),
      ),
    );
  }

  Widget subVerif(CicilEmas2Bloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.noHpStream$,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 'No hp Anda';
        return Text.rich(
          TextSpan(children: <TextSpan>[
            const TextSpan(
              text: 'Silahkan masukkan 5 digit OTP yang dikirim ke ',
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

  Widget otpText(CicilEmas2Bloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.otpErrorStream$,
      builder: (context, snapshot) {
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: OtpTextField(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                numberOfFields: 5,
                enabledBorderColor:
                    snapshot.hasData ? Colors.red : HexColor(primaryColorHex),
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
                  bloc.otpErrorChange(null);
                },
                onSubmit: (verificationCode) {
                  setState(() {
                    otpCode = verificationCode;
                  });
                  bloc.otpChange(verificationCode);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 3),
            if (snapshot.hasData)
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

  Widget actionButton(CicilEmas2Bloc bloc) {
    bool isValid = otpCode?.length == 5;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<bool>(
          stream: bloc.isLoading,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;
            if (isLoading == true) {
              return const ButtonLoading();
            }
            return Button1(
              btntext: 'Verifikasi',
              color: isValid ? null : Colors.grey,
              action: isValid
                  ? () {
                      bloc.isLoadingChange(true);
                      bloc.valOtpClick();
                    }
                  : null,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
