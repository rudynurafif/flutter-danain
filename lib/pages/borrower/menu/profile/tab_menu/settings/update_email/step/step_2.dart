import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_state.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';

import '../../../../../../../../widgets/widget_element.dart';

class Step2UpdateEmail extends StatefulWidget {
  final UbahEmailBloc emailBloc;
  const Step2UpdateEmail({super.key, required this.emailBloc});

  @override
  State<Step2UpdateEmail> createState() => _Step2UpdateEmailState();
}

class _Step2UpdateEmailState extends State<Step2UpdateEmail>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final LocalStorage storage = LocalStorage('todo_app.json');

  String? otpCode;
  bool otpValid = false;
  int _totalSeconds = 120;
  int _minutes = 2;
  int _seconds = 0;
  bool _timerEnded = false;

  bool isLoading = true;

  bool isNotValidOtp = false;

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
    didChangeDependencies$
        .exhaustMap((_) => widget.emailBloc.messageValidateOtp)
        .exhaustMap(messageValidasiOtp)
        .collect()
        .disposedBy(bag);
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
    final bloc = widget.emailBloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () => bloc.stepControl(1)),
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

  Stream<void> messageValidasiOtp(message) async* {
    if (message is UpdateEmailSuccessMessage) {
      final kode = storage.getItem('verif_email');
      print(kode);
      widget.emailBloc.kodeVerifikasiControl(kode);
      widget.emailBloc.stepControl(3);
    }

    if (message is UpdateEmailErrorMessage) {
      print(message.message);
      isNotValidOtp = true;
      // setState(() {
      //   isNotValidOtp = true;
      // });
    }
  }

  Widget subVerif(UbahEmailBloc bloc) {
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
                color: Color(0xff777777),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: hp,
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

  Widget otpText(UbahEmailBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: OtpTextField(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            numberOfFields: 6,
            enabledBorderColor: isNotValidOtp ? Colors.red : HexColor(primaryColorHex),
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
              bloc.otpControl(verificationCode);
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
        if (isNotValidOtp)
          const Subtitle2(
            text: 'Kode Otp yang anda masukan tidak valid',
            align: TextAlign.end,
            color: Colors.red,
          )
      ],
    );
  }

  Widget actionButton(UbahEmailBloc bloc) {
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
                  bloc.submitOtp();
                }
              : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
