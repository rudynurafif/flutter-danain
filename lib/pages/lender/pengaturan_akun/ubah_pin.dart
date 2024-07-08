import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/step/step_confirm.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/step/step_current.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/step/step_new.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin_bloc.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

class UbahPinLenderPage extends StatefulWidget {
  static const routeName = '/ubah_pin_lender';
  const UbahPinLenderPage({super.key});

  @override
  State<UbahPinLenderPage> createState() => _UbahPinLenderPageState();
}

class _UbahPinLenderPageState extends State<UbahPinLenderPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<UbahPinLenderBloc>().messagePin)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<UbahPinLenderBloc>().messageCheckPin)
        .exhaustMap(handleMessageCheck)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UbahPinLenderBloc>(context);
    final listWidget = [
      StepCurrentPin(pinBloc: bloc),
      StepNew(pinBloc: bloc),
      StepConfirmPin(pinBloc: bloc),
    ];
    return Stack(
      children: [
        StreamBuilder<int>(
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
        ),
        StreamBuilder<bool>(
          stream: bloc.isLoading,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;
            if (isLoading == true) {
              print('true bang');
              return const Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.3,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            print('false bang bang');

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Stream<void> handleMessage(message) async* {
    final bloc = BlocProvider.of<UbahPinLenderBloc>(context);
    bloc.isLoadingChange(false);
    if (message is UbahPinSuccess) {
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
      Future.delayed(const Duration(seconds: 2), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          Navigator.pop(context);
        }
      });
    }
    if (message is UbahPinError) {
      print(message.message);
      bloc.errorPinChange(message.message);
    }
  }

  Stream<void> handleMessageCheck(message) async* {
    final bloc = BlocProvider.of<UbahPinLenderBloc>(context);
    if (message is UbahPinSuccess) {
      bloc.stepChange(2);
    }
    if (message is UbahPinError) {
      print(message.message);
      if (message.message.startsWith('Maaf,')) {
        bloc.errorCurrentPinChange('Pin yang Anda masukkan salah');
      } else {
        context.showSnackBarError(message.message);
      }
    }
  }
}
