import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/update_bank_state.dart';
import 'package:flutter_danain/pages/lender/profile/info_bank/update_bank_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'info_bank_lender_bloc.dart';

class InfoBankLenderPage extends StatefulWidget {
  static const routeName = '/info_lender_bank';
  final String? username;
  final String? action;
  const InfoBankLenderPage({
    super.key,
    this.username,
    this.action,
  });

  @override
  State<InfoBankLenderPage> createState() => _InfoBankLenderPageState();
}

class _InfoBankLenderPageState extends State<InfoBankLenderPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final bankBloc = InfoBankLenderBloc();

  @override
  void initState() {
    didChangeDependencies$
        .exhaustMap((_) => bankBloc.updateBankMessageStream)
        .exhaustMap(handleMessageUpdate)
        .collect()
        .disposedBy(bag);
    super.initState();
    context.bloc<InfoLenderBankBloc>().getInfoBank();
    context.bloc<InfoLenderBankBloc>().errorMessage.listen((value) {
      if (value != null) {
        value.toToastError(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bankBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<InfoLenderBankBloc>();
    final listWidget = [
      UpdateBankPage(bBloc: bloc),
    ];
    return StreamBuilder<bool>(
      stream: bloc.isReady,
      builder: (context, snapshot) {
        final isReady = snapshot.data ?? false;
        if (isReady) {
          return StreamBuilder<int>(
            stream: bloc.step.stream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? 1;
              return WillPopScope(
                child: listWidget[data - 1],
                onWillPop: () async {
                  if (data < 2) {
                    Navigator.pop(context);
                  } else {
                    bloc.step.add(data - 1);
                  }
                  print(data);
                  return false;
                },
              );
            },
          );
        }
        return Scaffold(
          appBar: AppBarWidget(
            context: context,
            isLeading: true,
            title: 'Informasi Akun Bank',
          ),
          body: const LoadingDanain(),
        );
      },
    );
  }

  Stream<void> handleMessageUpdate(message) async* {
    if (message is UpdateBankSuccess) {
      BuildContext? dialogContext;

      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/images/profile/bank.svg',
            title: 'Akun Bank Berhasil Diubah',
            message:
                'Akun bank akan digunakan untuk melakukan pencairan pinjaman',
          );
        },
      ));

      Future.delayed(const Duration(seconds: 1), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          bankBloc.updateBankMessage.sink.add(null);
          bankBloc.stepController.sink.add(1);
        }
      });
    }

    if (message is UpdateBankError) {
      // ignore: use_build_context_synchronously
      context.showSnackBarError(message.message);
    }

    if (message is InvalidInformationMessageBank) {
      // ignore: use_build_context_synchronously
      context.showSnackBarError(
          'Terdapat error yang tidak diketahui silakan coba lagi beberapa saat');
    }
  }
}
