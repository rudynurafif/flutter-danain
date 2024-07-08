import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../data/constants.dart';
import '../../../../layout/appBar_prevCustom.dart';
import '../../../../widgets/widget_element.dart';
import '../new_detail_pendanaan/new_detail_pendanaan_bloc.dart';

class StepNewOtpPendanaan extends StatefulWidget {
  final NewDetailPendanaanBloc bloc;
  const StepNewOtpPendanaan({super.key, required this.bloc});

  @override
  State<StepNewOtpPendanaan> createState() => _StepNewOtpPendanaanState();
}

class _StepNewOtpPendanaanState extends State<StepNewOtpPendanaan> {
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
        children: [
          SubtitleExtra(
            text: 'Jika tidak menerima pesan, silakan ',
            color: HexColor('#777777'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timerEnded ? timerEnd(context) : timerNotEnd(context),
            ],
          )
        ],
      ),
    );
  }

  Widget timerEnd(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.bloc.reqOtpSubmit();
          setState(() {
            _totalSeconds = 120;
            _minutes = 2;
            _seconds = 0;
            _timerEnded = false;
            startTimer();
          });
        });
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: SubtitleExtra(
        text: 'kirim ulang',
        color: HexColor(lenderColor),
      ),
    );
  }

  Widget timerNotEnd(BuildContext context) {
    return Row(
      children: [
        SubtitleExtra(
          text: 'kirim ulang',
          color: HexColor('#777777'),
        ),
        SubtitleExtra(
          text:
              ' dalam ${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
          color: HexColor('#777777'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        widget.bloc.stepControl(1);
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
              const SizedBox(height: 40),
              actionButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget subVerif(NewDetailPendanaanBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.noTelpUser,
      builder: (context, snapshot) {
        final data = snapshot.data ?? '08xxxxxxxxxx';
        return Text.rich(
          TextSpan(
            children: <TextSpan>[
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
            ],
          ),
          textAlign: TextAlign.start,
        );
      },
    );
  }

  Widget otpText(NewDetailPendanaanBloc bloc) {
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
                  enabledBorderColor: snapshot.hasData ? HexColor('#EB5757') : HexColor('#DFE8E1'),
                  focusedBorderColor: HexColor('#28AF60'),
                  fillColor: HexColor('#F5F9F6'),
                  borderColor: HexColor('#DFE8E1'),
                  enabled: true,
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 0.95,
                  ),
                  cursorColor: HexColor('#288C50'),
                  fieldHeight: 47,
                  fieldWidth: 52,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 8),
              snapshot.hasData
                  ? const TextWidget(
                      text: 'Kode OTP yang dimasukkan tidak sesuai',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    )
                  : const SizedBox.shrink(),
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
                color: isValid ? HexColor(lenderColor) : HexColor('#ADB3BC'),
                action: isValid
                    ? () {
                        widget.bloc.isLoadingChange(true);
                        widget.bloc.validateOtpSubmit(otpCode!);
                      }
                    : null,
              );
            }),
        const SizedBox(height: 20),
      ],
    );
  }
}
