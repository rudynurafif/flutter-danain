import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/list_page.dart/step_1_aktivasi.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/list_page.dart/step_3_aktivasi.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/utils/loading.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';

import 'list_page.dart/component.dart';
import 'list_page.dart/step_2_aktivasi.dart';

class AktivasiPage extends StatefulWidget {
  static const routeName = '/aktivasi_page';
  const AktivasiPage({super.key});

  @override
  State<AktivasiPage> createState() => _AktivasiPageState();
}

class _AktivasiPageState extends State<AktivasiPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.bloc<AktivasiAkunBloc>();
    bloc.getMasterData();
    bloc.errorMessage.listen(
      (value) {
        if (value != null) {
          context.showSnackBarError(value);
        }
      },
    );
    bloc.isLoading.listen(
      (value) {
        try {
          if (value == true) {
            context.showLoading();
          } else {
            context.dismiss();
          }
        } catch (e) {
          context.dismiss();
        }
      },
    );
    bloc.infoBank.listen(
      (value) {
        if (value != null) {
          final data = value['data'] ?? {};
          if (value['status'] == 200) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalInfoBank(
                  bankName: data['bankAccount'],
                  nama: data['customerName'],
                  kotaBank: bloc.kotaBank.valueOrNull ?? '',
                  noRek: data['accountNumber'],
                  isValid: true,
                  action: () {
                    Navigator.pop(context);
                    bloc.postDataPendukung();
                  },
                );
              },
            );
          } else {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalInfoBank(
                  bankName: data['bankAccount'],
                  nama: data['customerName'],
                  kotaBank: bloc.kotaBank.valueOrNull ?? '',
                  noRek: data['accountNumber'],
                  isValid: false,
                );
              },
            );
          }
        }
      },
    );
    bloc.isPostDone.listen(
      (value) async {
        if (value == true) {
          await navigate();
        }
      },
    );
  }

  Future<void> navigate() async {
    BuildContext? dialogContext;

    unawaited(
      showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/images/icons/check.svg',
            title: 'Data Pendukung Berhasil Disimpan',
            message: 'Mulai nikmati layanan lengkap kami dan  rasakan pengalaman terbaik Anda.',
          );
        },
      ),
    );
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.routeName,
            (route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<AktivasiAkunBloc>();
    final listWidget = [
      Step2Aktivasi(aktivasiBloc: bloc),
      Step1Aktivasi(aktivasiBloc: bloc),
      Step3Aktivasi(aktivasiBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.step.stream,
      builder: (context, snapshot) {
        final step = snapshot.data ?? 1;
        return WillPopScope(
          child: listWidget[step - 1],
          onWillPop: () async {
            if (step == 1) {
              Navigator.pop(context);
            } else {
              bloc.step.add(step - 1);
            }
            return false;
          },
        );
      },
    );
  }
}
