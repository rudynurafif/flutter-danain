import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/new_password_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot_password_page';
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final fpBloc = ForgotPasswordBloc();
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fpBloc.emailController.hasValue
        ? emailController.text = fpBloc.emailController.value
        : emailController.clear();
  }

  @override
  void dispose() {
    fpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: fpBloc.currentStepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 0;
        return Scaffold(
          appBar: previousCustomWidget(
            context,
            () {
              data == 0 ? Navigator.pop(context) : fpBloc.prevStep();
            },
          ),
            body: FutureBuilder<int?>(
              future: rxPrefs.getInt('user_status'),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  // Handle the loading state if necessary.
                  return CircularProgressIndicator();
                } else if (snapshots.hasError) {
                  // Handle the error state if necessary.
                  return Text('Error: ${snapshots.error}');
                } else {
                  int? userStatus = snapshots.data;

                  return WillPopScope(
                    onWillPop: () async {
                      if (data == 0) {
                        Navigator.pop(context);
                      } else {
                        fpBloc.prevStep();
                      }
                      return false;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: data == 0 ? step1FP(context, userStatus!) : step2FP(context),
                    ),
                  );
                }
              },
            )

        );
      },
    );
  }

  Widget step1FP(BuildContext context, int userStatus) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(userStatus == 2 ? 'assets/images/forgot_password/forgot_password.svg' : 'assets/lender/onboarding/Email.svg'),
        const SizedBox(height: 24),
        const Subtitle2(
          text: forgotPasswordDesc,
          color: Color(0xff777777),
          align: TextAlign.center,
        ),
        const SizedBox(height: 24),
        formEmail(context),
        const SizedBox(height: 32),
        buttonEmail(context)
      ],
    );
  }

  Widget formEmail(BuildContext context) {
    return StreamBuilder<String>(
      stream: fpBloc.emailStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Alamat'),
            const SizedBox(height: 4),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: inputDecorNoError(
                context,
                'Contoh: jhondhoe@gmail.com',
              ),
              controller: emailController,
              onChanged: (value) => fpBloc.emailChange(value),
            ),
          ],
        );
      },
    );
  }

  Widget buttonEmail(BuildContext context) {
    return StreamBuilder<bool>(
      stream: fpBloc.buttonStep1Controller,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return Button1(
          color: isValid ? null : HexColor('#ADB3BC'),
          btntext: 'Atur Ulang Kata Sandi',
          action: isValid
              ? () {
                  fpBloc.nextStep();
                }
              : null,
        );
      },
    );
  }

  Widget step2FP(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/forgot_password/send_email.svg'),
        const SizedBox(height: 24),
        const Headline2(text: checkEmail),
        const SizedBox(height: 8),
        textSendEmail(context),
        const SizedBox(height: 54),
        buttonResend(context)
      ],
    );
  }

  Widget textSendEmail(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          const TextSpan(
            text: 'Link verifikasi telah dikirim ke ',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: fpBloc.emailController.value,
            style: const TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const TextSpan(
            text:
                '. Segera cek email dan klik tombol “Ubah Kata Sandi” untuk melanjutkan proses pendaftaran.',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buttonResend(BuildContext context) {
    return Button1(
      btntext: 'Kirim Ulang Verifikasi',
      action: () {
        Navigator.pushNamed(context, NewPasswordPage.routeName);
      },
    );
  }
}
