import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousHelpCustome.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/register/register_bloc.dart';
import 'package:flutter_danain/pages/borrower/register/register_step/change_email.dart';
import 'package:flutter_danain/pages/borrower/register/register_step/email_success.dart';
import 'package:flutter_danain/pages/borrower/register/register_step/step_1.dart';
import 'package:flutter_danain/pages/borrower/register/register_step/step_2.dart';
import 'package:flutter_danain/pages/borrower/register/register_step/step_3.dart';
import 'package:flutter_danain/pages/borrower/register/register_step/step_4.dart';
import 'package:flutter_danain/pages/borrower/register/register_step/wiliyah_mitra_after_login.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'syaratnketentuan_screen.dart';

class RegisterIndex extends StatefulWidget {
  static const routeName = '/register_page';
  const RegisterIndex({super.key});

  @override
  State<RegisterIndex> createState() => _RegisterIndexState();
}

class _RegisterIndexState extends State<RegisterIndex> {
  final regisBloc = RegisterBloc();

  bool isLoading = true;

  void initGetData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final stepSementara = prefs.getInt('step_sementara');
    final emailSementara = prefs.getString('email_sementara');
    if (stepSementara != null) {
      regisBloc.stepController.sink.add(stepSementara);
      print('step_sementara');
      print(stepSementara);
    }

    if (emailSementara != null) {
      regisBloc.emailController.add(emailSementara);
    }

    final tokenSementara = prefs.getString('token_sementara');
    if (tokenSementara != null) {
      regisBloc.tokenController.sink.add(tokenSementara);
    }

    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    initGetData();
  }

  @override
  void dispose() {
    regisBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: regisBloc.stepStream,
      builder: (context, snapshot) {
        print('sama dengan sih ${snapshot.data}');
        final int data = snapshot.data ?? 0;
        bool isHelp = true;
        if (data == 10) {
          isHelp = false;
        }
        return WillPopScope(
          child: Scaffold(
            appBar: previousUseHelpWidget(
              context,
              () {
                if (data == 10) {
                  regisBloc.stepController.add(0);
                } else if (data == 0) {
                  print('sama dengan if $data');
                  Navigator.pop(context);
                } else if (data == 3) {
                  print('sama dengan 3');
                  Navigator.pushNamed(context, PreferencePage.routeName);
                } else if (data == 4) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PreferencePage.routeName,
                    (route) => false,
                  );
                } else if (data == 6) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PreferencePage.routeName,
                    (route) => false,
                  );
                } else {
                  print('sama dengan else');
                  regisBloc.prevStep();
                }
              },
              isHelp,
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : bodyBuilder(context, snapshot.data ?? 0),
          ),
          onWillPop: () async {
            final int data = snapshot.data ?? 0;
            if (data == 0) {
              Navigator.pop(context);
            } else if (data == 3) {
              await Navigator.pushNamedAndRemoveUntil(
                context,
                PreferencePage.routeName,
                (route) => false,
              );
            } else if (data == 4) {
              await Navigator.pushNamedAndRemoveUntil(
                context,
                PreferencePage.routeName,
                (route) => false,
              );
            } else {
              regisBloc.prevStep();
            }
            return false;
          },
        );
      },
    );
  }

  Future<void> _loadData(int? data) async {
    // Perform asynchronous data loading here based on the 'data' value if needed.
  }

  Widget bodyBuilder(BuildContext context, int step) {
    switch (step) {
      case 0:
        return Step1Regis(regisBloc: regisBloc);
      case 1:
        return Step2Regis(regisBloc: regisBloc);
      case 2:
        return Step3Regis(regisBloc: regisBloc);
      case 3:
        return Step4Regis(regisBloc: regisBloc);
      case 4:
        return EmailSuccess(regisBloc: regisBloc);
      case 5:
        return ChangeEmailRegister(regisBloc: regisBloc);
      case 6:
        return WilayahMitraAfterLogin(regisBloc: regisBloc);
      case 10:
        return SyaratnKetentuanPage(rgBloc: regisBloc);
      default:
        return const SizedBox.shrink();
    }
  }
}
