import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/profile/info_bank/info_bank_lender_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import '../../../borrower/menu/profile/tab_menu/info_bank/update_bank_state.dart';

class CheckingPinPage extends StatefulWidget {
  final InfoBankLenderBloc tdBloc;
  final String action;
  const CheckingPinPage(
      {super.key, required this.tdBloc, required this.action});

  @override
  State<CheckingPinPage> createState() => _CheckingPinPageState();
}

class _CheckingPinPageState extends State<CheckingPinPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  TextEditingController pinController = TextEditingController();
  String errorText = '';
  final defaultPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      color: HexColor(lenderColor),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: HexColor(lenderColor),
      ),
    ),
  );
  final errorPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      color: Colors.red,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: Colors.red,
      ),
    ),
  );

  void initState() {
    // TODO: implement initState
    widget.tdBloc.errorPinController.add(null);
    widget.tdBloc.updateBankMessage.add(null);
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => widget.tdBloc.updateBankMessageStream)
        .exhaustMap(handleMessageUpdate)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => widget.tdBloc.updatePinMessageStream)
        .exhaustMap(handlePinMessage)
        .collect()
        .disposedBy(bag);
  }

  Stream<bool> handlePinMessage(message) async* {
    print("status pin message $message");
    if (message == true) {
      widget.tdBloc.updateBankLender();
    }
  }

  Stream<void> handleMessageUpdate(message) async* {
    if (message is UpdateBankSuccess) {
      BuildContext? dialogContext;
      print('message update succeess $message');
      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return ModalPopUpNoClose(
            icon: 'assets/lender/home/bank.svg',
            title: widget.action == 'Ubah'
                ? 'Akun Bank Berhasil Diubah'
                : 'Akun Bank Berhasil Disimpan',
            message: widget.action == 'Ubah'
                ? 'Akun bank berhasil diubah, sekarang Anda bisa melakukan pencairan dana'
                : 'Akun bank berhasil ditambahkan, sekarang Anda bisa melakukan pencairan dana',
          );
        },
      ));

      Future.delayed(const Duration(seconds: 1), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          widget.tdBloc.updateBankMessage.sink.add(null);

          Navigator.of(context).pushNamedAndRemoveUntil(
              HomePageLender.routeNeme, (Route<dynamic> route) => false);
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

  @override
  Widget build(BuildContext context) {
    final bloc = widget.tdBloc;
    return WillPopScope(
      child: StreamBuilder<String?>(
        stream: bloc.errorPinStream,
        builder: (context, snapshot) {
          return PinWithForgot(
            titleAppbar: 'Masukkan PIN',
            actionBack: () {
              bloc.stepController.sink.add(1);
              bloc.errorPinController.add(null);
            },
            onChangePin: (value) {
              debugPrint('onChanged: $value');
              if (value.length < 6) {
                bloc.errorPinController.add(null);
                bloc.updateBankMessage.add(null);
              }
              bloc.pinsController.sink.add(value);
            },
            onCompletePin: (pin) {
              if (pin.length < 6) {
                bloc.errorPinController.add(null);
                bloc.updateBankMessage.add(null);
              } else {
                bloc.sendingPin(pin);
              }
            },
            isNavigate: false,
            errorPin: snapshot.data,
          );
        },
      ),
      onWillPop: () async {
        bloc.stepController.sink.add(1);
        bloc.errorPinController.add(null);
        return false;
      },
    );
  }
}
