import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/otp_state.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/step/step_pemberitahuan.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/step/step_pilih_alasan.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/step/step_validasi_otp.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/tutup_akun_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class TutupAkunIndex extends StatefulWidget {
  static const routeName = '/tutup_akun_page';
  const TutupAkunIndex({super.key});

  @override
  State<TutupAkunIndex> createState() => _TutupAkunIndexState();
}

class _TutupAkunIndexState extends State<TutupAkunIndex>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final bloc = TutupAkunBloc();

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc.initGetData();
    didChangeDependencies$
        .exhaustMap((_) => bloc.reqOtpMessageStream)
        .exhaustMap(handleReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => bloc.validateOtpMessageStream)
        .exhaustMap(handleValidasiOtp)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.isReadyStream,
      builder: (context, snapshot) {
        final isReady = snapshot.data ?? false;
        if (isReady == true) {
          return StreamBuilder<int>(
            stream: bloc.stepStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? 1;
              switch (data) {
                case 1:
                  return StepPemberitahuan(bloc: bloc);
                case 2:
                  return StepPilihAlasan(bloc: bloc);
                case 3:
                  return OtpPenutupanAkun(bloc: bloc);
                default:
                  return Container();
              }
            },
          );
        } else {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Stream<void> handleReqOtp(message) async* {
    if (message is OtpMessageSuccess) {
      bloc.stepController.sink.add(3);
    }

    if (message is OtpMessageError) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> handleValidasiOtp(message) async* {
    if (message is OtpMessageSuccess) {
      BuildContext? dialogContext;
      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/images/icons/check.svg',
            title: 'Pengajuan Penutupan Terkirim',
            message:
                'Danain akan segera memproses pengajuan penutupan akun Anda.',
          );
        },
      ));
      Future.delayed(const Duration(seconds: 1), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.routeName,
            (route) => false,
          );
        }
      });
    }

    if (message is OtpMessageError) {
      context.showSnackBarError(message.message);
    }
  }
}
