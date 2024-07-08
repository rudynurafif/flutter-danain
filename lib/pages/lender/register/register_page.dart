import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/pages/lender/register/register_lender_state.dart';
import 'package:flutter_danain/pages/lender/register/step/step_1.dart';
import 'package:flutter_danain/pages/lender/register/step/step_2.dart';
import 'package:flutter_danain/pages/lender/register/step/step_3.dart';
import 'package:flutter_danain/pages/lender/register/step/step_4.dart';
import 'package:flutter_danain/pages/lender/register/step/step_5.dart';
import 'package:flutter_danain/pages/lender/register/step/step_6.dart';
import 'package:flutter_danain/pages/lender/register/step/step_7.dart';
import 'package:flutter_danain/pages/lender/register/step/step_8.dart';
import 'package:flutter_danain/pages/lender/register/step/syarat_ketentuan_screen_2.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class RegistrasiLenderPage extends StatefulWidget {
  static const routeName = '/registrasi_lender';
  const RegistrasiLenderPage({super.key});

  @override
  State<RegistrasiLenderPage> createState() => _RegistrasiLenderPageState();
}

class _RegistrasiLenderPageState extends State<RegistrasiLenderPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  void initState() {
    initializeValues();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<RegisterLenderBloc>().isComplete)
        .exhaustMap(isComplete)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<RegisterLenderBloc>().messageReqOtp)
        .exhaustMap(messageReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<RegisterLenderBloc>().messageSendOtp)
        .exhaustMap(messageSendOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap(
            (_) => context.bloc<RegisterLenderBloc>().messageSendRegister)
        .exhaustMap(messageSendRegister)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap(
            (_) => context.bloc<RegisterLenderBloc>().messageSendPinRegister)
        .exhaustMap(messageSendPin)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<RegisterLenderBloc>().messageSendEmail)
        .exhaustMap(messageSendEmail)
        .collect()
        .disposedBy(bag);
    super.initState();
  }

  Future<void> initializeValues() async {
    final registerLenderBloc = BlocProvider.of<RegisterLenderBloc>(context);
    final stepSementara = await rxPrefs.getInt('step_sementara');
    final emailSementara = await rxPrefs.getString('email_ubah');

    if (registerLenderBloc.emailValue.valueOrNull == null) {
      registerLenderBloc.emailControl(emailSementara!);
    }
    print('showing email $emailSementara');
    registerLenderBloc.stepControl(stepSementara!);

    // Rest of your initialization code...
  }

  Stream<void> messageReqOtp(message) async* {
    print('message otp req $message');
    final registerLenderBloc = BlocProvider.of<RegisterLenderBloc>(context);
    if (message is RegisterLenderSuccessMessage) {
      registerLenderBloc.stepControl(2);
    }

    if (message is RegisterLenderErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> messageSendOtp(message) async* {
    final registerLenderBloc = BlocProvider.of<RegisterLenderBloc>(context);
    if (message is RegisterLenderSuccessMessage) {
      registerLenderBloc.stepControl(3);
    }

    if (message is RegisterLenderErrorMessage) {
      print('message send req $message');
      if (message != null) {
        registerLenderBloc.stepControl(2);
        registerLenderBloc.otpControlError(true);
      }
    }
  }

  Stream<void> messageSendPin(message) async* {
    print('message send req $message');
    final registerLenderBloc = BlocProvider.of<RegisterLenderBloc>(context);
    if (message is RegisterLenderSuccessMessage) {
      registerLenderBloc.stepControl(7);
      registerLenderBloc.sendEmail();
    }

    if (message is RegisterLenderErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> messageSendRegister(message) async* {
    print('message send req $message');
    final registerLenderBloc = BlocProvider.of<RegisterLenderBloc>(context);
    if (message is RegisterLenderSuccessMessage) {
      registerLenderBloc.stepControl(4);
    }

    if (message is RegisterLenderErrorMessage) {
      registerLenderBloc.stepControl(3);
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> messageSendEmail(message) async* {
    print('message send message req $message');
    final registerLenderBloc = BlocProvider.of<RegisterLenderBloc>(context);
    if (message is RegisterLenderSuccessMessage) {
      print('message success $message');
      registerLenderBloc.stepControl(7);
      context.showSnackBarSuccess('Success sending to your email');
    }

    if (message is RegisterLenderErrorMessage) {
      registerLenderBloc.stepControl(8);
      print('message bad $message');
      context.showSnackBarError(message.message);
    }
  }

  @override
  void dispose() {
    context.bloc<RegisterLenderBloc>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RegisterLenderBloc>(context);
    final List<Widget> listWidget = [
      Step1RegisLender(regisBloc: bloc),
      Step2RegisLender(regisBloc: bloc),
      Step3RegisLender(regisBloc: bloc),
      Step4RegisLender(regisBloc: bloc),
      Step5RegisLender(regisBloc: bloc),
      Step6RegisLender(regisBloc: bloc),
      Step7RegisLender(regisBloc: bloc),
      Step8RegisLender(regisBloc: bloc),
    ];
    return StreamBuilder(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return WillPopScope(
          child: data == 10
              ? SyaratDanKetentuanLender(bloc: bloc)
              : listWidget[data - 1],
          onWillPop: () async {
            if (data == 1) {
              Navigator.pop(context);
            } else if (data == 10) {
              bloc.stepControl(1);
            } else {
              bloc.stepControl(data - 1);
            }
            return false;
          },
        );
      },
    );
  }

  Stream<void> isComplete(value) async* {
    final bloc = BlocProvider.of<RegisterLenderBloc>(context);
    if (value == true) {
      bloc.sendPin();
    }
  }
}
