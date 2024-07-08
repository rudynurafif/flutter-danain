import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/change_phone_number/change_phone_number_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/verification_complete_page.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_bloc.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';

class Step5Verif extends StatefulWidget {
  final StepVerifBloc stepBloc;
  const Step5Verif({super.key, required this.stepBloc});

  @override
  State<Step5Verif> createState() => _Step5VerifState();
}

class _Step5VerifState extends State<Step5Verif> {
  String? otpCode;
  bool otpValid = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline1(text: 'Verifikasi OTP'),
              const SizedBox(height: 8),
              subVerif(context),
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

  Widget subVerif(BuildContext context) {
    return const Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
          text: 'Silahkan masukkan 6 digit OTP yang dikirim ke',
          style: TextStyle(
            color: Color(0xff777777),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: ' +62 856 7713 001',
          style: TextStyle(
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
      stream: widget.stepBloc.otpValidationStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            Center(
              child: OtpTextField(
                numberOfFields: 6,
                enabledBorderColor:
                    snapshot.hasError ? Colors.red : HexColor('#E9F6EB'),
                fieldWidth: MediaQuery.of(context).size.width / 8,
                borderColor: HexColor(primaryColorHex),
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                showFieldAsBox: true,
                borderWidth: 0.6,
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
            if (snapshot.hasError)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Subtitle2(
                    text: snapshot.error! as String,
                    color: Colors.red,
                  ),
                ],
              )
          ],
        );
      },
    );
  }

  Widget resendOtp(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubtitleExtra(text: 'Jika tidak menerima pesan, silakan'),
          TextButton(
            onPressed: () {},
            child: Headline3500(
              text: 'Kirim Ulang',
              color: HexColor(primaryColorHex),
            ),
          )
        ],
      ),
    );
  }

  Widget actionButton(BuildContext context) {
    final bool isValid = otpCode?.length == 6;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Button1(
          btntext: 'Verifikasi',
          color: isValid ? null : Colors.grey,
          action: isValid
              ? () {
                  widget.stepBloc.otpValidate(otpCode!);
                  setState(() {
                    otpValid = widget.stepBloc.otpValidationController.value;
                  });
                  if (otpValid) {
                    showAlert();
                  }
                }
              : null,
        ),
        const SizedBox(height: 20),
        if (isValid)
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ChangeNoHpPage.routeName);
              },
              child: Headline3(
                text: 'Ubah Nomor HP',
                color: HexColor(primaryColorHex),
              ),
            ),
          ),
      ],
    );
  }
}
