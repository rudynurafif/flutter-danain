import 'dart:convert';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_bloc2.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_state.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/step/accept_pinjaman.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/step/otp_privy.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/step/penawaran_pinjaman_detail.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/loading/loading_payung.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:localstorage/localstorage.dart';

class PenawaranPinjamanPage extends StatefulWidget {
  static const routeName = '/penawaran_pinjaman_detail';
  final int? idjaminan;
  final int? idproduk;
  const PenawaranPinjamanPage({super.key, this.idjaminan, this.idproduk});

  @override
  State<PenawaranPinjamanPage> createState() => _PenawaranPinjamanPageState();
}

class _PenawaranPinjamanPageState extends State<PenawaranPinjamanPage>
    with DidChangeDependenciesStream, DisposeBagMixin {
  final LocalStorage storage = LocalStorage('todo_app.json');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as PenawaranPinjamanPage?;
    if (args != null) {
      context
          .bloc<PenawaranPinjamanBloc2>()
          .getPinjamanControl(args.idjaminan!, args.idproduk!);
    }
  }

  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<PenawaranPinjamanBloc2>().messageReqOtp)
        .exhaustMap(messageReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<PenawaranPinjamanBloc2>().message)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PenawaranPinjamanBloc2>(context);
    final List<Widget> body = [
      PenawaranPinjamanDetail(ppBloc: bloc),
      OtpPrivyPinjaman(ppBloc: bloc),
      const LoadingDanain(),
      AcceptPinjaman(ppBloc: bloc)
    ];
    return StreamBuilder<int>(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return WillPopScope(
          child: data == 10 ? SyaratKetentuan(bloc: bloc) : body[data - 1],
          onWillPop: () async {
            switch (data) {
              case 1:
                Navigator.pop(context);
                break;
              case 2:
                bloc.stepControl(1);
                break;
              case 4:
                await Navigator.of(context).pushNamedAndRemoveUntil(
                    HomePage.routeName, (Route<dynamic> route) => false);
                break;
              case 10:
                bloc.stepControl(1);
                break;
              default:
                print('gabisa');
            }

            return false;
          },
        );
      },
    );
  }

  Stream<void> messageReqOtp(message) async* {
    final bloc = BlocProvider.of<PenawaranPinjamanBloc2>(context);
    if (message is PenawaranPinjamanSuccessMessage) {
      bloc.stepControl(2);
    }

    if (message is PenawaranPinjamanErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> handleMessage(message) async* {
    final bloc = BlocProvider.of<PenawaranPinjamanBloc2>(context);
    if (message is PenawaranPinjamanSuccessMessage) {
      final response = storage.getItem('penawaran_pinjaman');
      print(response);
      bloc.responseControl(jsonDecode(response));
      bloc.stepControl(4);
    }

    if (message is PenawaranPinjamanErrorMessage) {
      if (message.message == 'Unauthorized. Invalid or expired code OTP.') {
        bloc.otpControlError('Kode OTP yang dimasukkan tidak sesuai');
        bloc.stepControl(2);
      } else {
        await showDialog(
          context: context,
          builder: (context) => ModalPopUpNoClose(
            icon: 'assets/lender/home/payung2.svg',
            title: 'Transaksi Tidak Dapat Diproses',
            message:
                'Mohon maaf atas kendala yang terjadi, silakan coba beberapa saat lagi',
            actions: [
              Button2(
                btntext: 'Kembali',
                action: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.routeName, (Route<dynamic> route) => false);
                },
              )
            ],
          ),
        );
      }
    }
  }
}
