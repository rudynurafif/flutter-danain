import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/request_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class Step1ForgotPassword extends StatefulWidget {
  final ForgotPasswordEmailBloc fpBloc;
  const Step1ForgotPassword({super.key, required this.fpBloc});

  @override
  State<Step1ForgotPassword> createState() => _Step1ForgotPasswordState();
}

class _Step1ForgotPasswordState extends State<Step1ForgotPassword> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousWidget(context),
        body: FutureBuilder<int?>(
          future: rxPrefs.getInt('user_status'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Handle the loading state if necessary.
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle the error state if necessary.
              return Text('Error: ${snapshot.error}');
            } else {
              int? data = snapshot.data;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(data == 2 ? 'assets/images/forgot_password/forgot_password.svg' : 'assets/lender/onboarding/Email.svg'),
                    const SizedBox(height: 24),
                     Subtitle2(
                      text: data == 2 ?  forgotPasswordDesc : forgotPasswordDescLender,
                      color: Color(0xff777777),
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    formEmail(widget.fpBloc, data!),
                    const SizedBox(height: 32),
                    buttonEmail(widget.fpBloc, data)
                  ],
                ),
              );
            }
          },
        )

    );
  }

  Widget formEmail(ForgotPasswordEmailBloc bloc, int data) {
    return StreamBuilder<String>(
      stream: bloc.emailStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Alamat Email'),
            const SizedBox(height: 4),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: data == 2 ? inputDecorNoError(
                context,
                'Contoh: jhondhoe@gmail.com',

              ) : inputDecorNoErrorLender(
                context,
                'Contoh: jhondhoe@gmail.com',

              ),
              controller: emailController,
              onChanged: bloc.emailControl,
            ),
          ],
        );
      },
    );
  }

  Widget buttonEmail(ForgotPasswordEmailBloc bloc, int data) {
    return StreamBuilder<bool>(
      stream: bloc.isValidEmailStream,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        if(data == 2) {
          return Button1(
            color: isValid ? null : HexColor('#ADB3BC'),
            btntext: 'Atur Ulang Kata Sandi',
            action: isValid
                ? () {
              bloc.submit();
            }
                : null,
          );
        } else{
          return Button1Lender(
            color: isValid ? null : HexColor('#ADB3BC'),
            btntext: 'Atur Ulang Kata Sandi',
            action: isValid
                ? () {
              bloc.submit();
            }
                : null,
          );
        }
      },
    );
  }
}
