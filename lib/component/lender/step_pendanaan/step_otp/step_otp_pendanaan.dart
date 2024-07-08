import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

class StepOtpPendanaan extends StatefulWidget {
  final PendanaanBloc bloc;
  const StepOtpPendanaan({super.key, required this.bloc});

  @override
  State<StepOtpPendanaan> createState() => _StepOtpPendanaanState();
}

class _StepOtpPendanaanState extends State<StepOtpPendanaan> {
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
        widget.bloc.reqOtpSubmit();
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
      appBar: previousCustomWidget(context, () {
        widget.bloc.stepControl(3);
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
              otpText(widget.bloc),
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

  Widget subVerif(PendanaanBloc pBloc) {
    return StreamBuilder<String>(
      stream: pBloc.noTelpUser,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 'Nomor anda';
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

  Widget otpText(PendanaanBloc bloc) {
    return StreamBuilder<String?>(
        stream: bloc.errorOtp,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: OtpTextField(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  numberOfFields: 5,
                  enabledBorderColor: snapshot.hasData
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
                    bloc.errorOtpChange(null);
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
              if (snapshot.hasData)
                Subtitle2(
                  text: snapshot.data!,
                  color: HexColor('#EB5757'),
                  align: TextAlign.end,
                )
            ],
          );
        });
  }

  Widget actionButton(BuildContext context) {
    bool isValid = otpCode?.length == 5;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<bool>(
          stream: widget.bloc.isLoadingButton,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;
            if (isLoading == true) {
              return const ButtonLoading();
            }
            return Button1(
              btntext: 'Verifikasi',
              color: isValid ? HexColor(lenderColor) : Colors.grey,
              action: isValid
                  ? () {
                      widget.bloc.isLoadingChange(true);
                      widget.bloc.validateOtpSubmit();
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
