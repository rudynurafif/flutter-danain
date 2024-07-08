import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class Step8RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step8RegisLender({super.key, required this.regisBloc});

  @override
  State<Step8RegisLender> createState() => _Step8RegisLenderState();
}

class _Step8RegisLenderState extends State<Step8RegisLender> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  TextEditingController emailController = TextEditingController();
  var emailSementara;
  @override
  void initState() {
    widget.regisBloc.errorEmailControl('');
    widget.regisBloc.emailValue.add('');

    initializeValues();
    // widget.regisBloc.emailControlNull('');
    super.initState();
  }
  Future<void> initializeValues() async {
     emailSementara = await rxPrefs.getString('email_ubah');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: previousTitleCustom(context, '', () {
          widget.regisBloc.stepControl(7);
          widget.regisBloc.emailControl(emailSementara);
        }),
        body: FutureBuilder<int?>(
          future: rxPrefs.getInt('user_status'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Handle the loading state if necessary.
              return const CircularProgressIndicator();
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
                    const Subtitle1(
                      text: 'Masukkan email baru untuk mengirimkan email verifikasi akun Anda.',
                      color: Color(0xff777777),
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    formEmail(widget.regisBloc, data!),
                    const SizedBox(height: 32),
                    buttonEmail(widget.regisBloc, data)
                  ],
                ),
              );
            }
          },
        )

    );
  }

  Widget formEmail(RegisterLenderBloc bloc, int data) {
    return StreamBuilder<String?>(
      stream: bloc.emailError$,
      builder: (context, snapshot) {
        print('chat email error${snapshot.data}');
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Alamat Email',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (val) {
                    _debounce(() {
                      // Perform the action you want after typing is finished
                      bloc.emailControl(val);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: formEmailPlaceHolder,
                    hintStyle: TextStyle(color: HexColor('#BEBEBE'), fontSize: 14),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    errorText: snapshot.data != null ? '' : null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor('#DDDDDD')),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF27AE60)),
                    ),
                  ),
                ),

                if (snapshot.hasData)
                  Padding(
                    padding: const EdgeInsets.only(top: 66),
                    child: Subtitle2(
                      text: snapshot.data!,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ],
        );
      },
    );
  }

  void _debounce(Function() callback) {
    // const Duration debounceDuration = Duration(milliseconds: 0);
    // Timer? timer;

    // timer = Timer(debounceDuration, callback);
  }

  Widget buttonEmail(RegisterLenderBloc bloc, int data) {
    return StreamBuilder<String?>(
        stream: bloc.emailError$,
        builder: (context, snapshot)
    {
      return Button1Lender(
        color:snapshot.hasData || !bloc.emailValue.hasValue || bloc.emailValue.valueOrNull == '' ? HexColor('#ADB3BC') : null,
        btntext: 'Ubah Alamat Email',
        action:snapshot.hasData || !bloc.emailValue.hasValue || bloc.emailValue.valueOrNull == '' ? null : () {
          widget.regisBloc.sendEmail();

          rxPrefs.setString('email_ubah', widget.regisBloc.emailValue.valueOrNull );

        },
      );
    }
    );
  }
}
