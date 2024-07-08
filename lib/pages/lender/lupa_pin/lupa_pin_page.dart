import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_bloc.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_state.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/step/step_otp.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:localstorage/localstorage.dart';
import 'step/step_confirm.dart';
import 'step/step_new_pin.dart';

class LupaPinPage extends StatefulWidget {
  static const routeName = '/lupa_pin';
  const LupaPinPage({super.key});

  @override
  State<LupaPinPage> createState() => _LupaPinPageState();
}

class _LupaPinPageState extends State<LupaPinPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    context.bloc<LupaPinBloc>().getOtp();
    context.bloc<LupaPinBloc>().getDataUser();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LupaPinBloc>().messageReqOtp)
        .exhaustMap(messagReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LupaPinBloc>().messageResendOtp)
        .exhaustMap(messageResend)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LupaPinBloc>().messageValidateOtp)
        .exhaustMap(messageValidate)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LupaPinBloc>().messageCheckPin)
        .exhaustMap(messageCheckPin)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LupaPinBloc>(context);
    final List<Widget> listWidget = [
      StepOtpLupaPin(lpBloc: bloc),
      StepNewPin(lpBloc: bloc),
      StepConfirm(lpBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final step = snapshot.data ?? 1;
        return WillPopScope(
          child: listWidget[step - 1],
          onWillPop: () async {
            if (step == 1) {
              Navigator.pop(context);
            } else {
              bloc.stepChange(step - 1);
            }
            return false;
          },
        );
      },
    );
  }

  Stream<void> messagReqOtp(message) async* {
    print(message);
    final bloc = BlocProvider.of<LupaPinBloc>(context);

    if (message is LupaPinSuccessMessage) {
      bloc.isValidChange(true);
    }

    if (message is LupaPinErrorMessage) {
      BuildContext? dialogContext;
      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/images/icons/warning_red.svg',
            title: 'Pembatasan Akses Lupa PIN',
            message:
                'Terdapat percobaan yang berulang untuk mengakses Lupa PIN. Harap tunggu 10 menit sebelum coba kembali',
          );
        },
      ));
      Future.delayed(const Duration(seconds: 2), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          Navigator.pop(context);
        }
      });
    }
  }

  Stream<void> messageResend(message) async* {
    print(message);
    if (message is LupaPinSuccessMessage) {
      print('Dapet bang aman');
    }

    if (message is LupaPinErrorMessage) {
      BuildContext? dialogContext;
      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/images/icons/warning_red.svg',
            title: 'Pembatasan Akses Lupa PIN',
            message:
                'Terdapat percobaan yang berulang untuk mengakses Lupa PIN. Harap tunggu 10 menit sebelum coba kembali',
          );
        },
      ));
      Future.delayed(const Duration(seconds: 2), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          Navigator.pop(context);
        }
      });
    }
  }

  Stream<void> messageValidate(message) async* {
    final bloc = BlocProvider.of<LupaPinBloc>(context);
    bloc.isLoadingChange(false);
    if (message is LupaPinSuccessMessage) {
      final LocalStorage storage = LocalStorage('todo_app.json');
      final data = storage.getItem('forgot_pin_key');
      bloc.keyChange(data['key']);
      bloc.stepChange(2);
    }

    if (message is LupaPinErrorMessage) {
      print(message.message);
      bloc.errorOtpChange('Kode OTP yang dimasukkan tidak sesuai');
    }
  }

  Stream<void> messageCheckPin(message) async* {
    print(message);
    if (message is LupaPinSuccessMessage) {
      BuildContext? dialogContext;
      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/lender/register/shield_pin.svg',
            title: 'PIN Berhasil Diubah',
            message:
                'PIN akan digunakan untuk otorisasi penggunaan akun maupun transaksi',
          );
        },
      ));
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (dialogContext != null) {
            Navigator.of(dialogContext!).pop();
            Navigator.pushNamed(context, HomePageLender.routeNeme);
          }
        },
      );
    }

    if (message is LupaPinErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }
}
