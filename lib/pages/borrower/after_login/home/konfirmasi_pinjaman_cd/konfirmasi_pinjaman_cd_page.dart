import 'dart:convert';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_cd_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/konfirmasi_pinjaman_cd/step/accept_pinjaman_cd.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/konfirmasi_pinjaman_cd/step/detail_konfrmasi_pinjaman.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/konfirmasi_pinjaman_cd/step/otp_privy.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_state.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:localstorage/localstorage.dart';

class KonfirmasiPinjamanCDPage extends StatefulWidget {
  static const routeName = '/konfirmasi_pinjaman_detail';
  final int? idPengajuan;
  const KonfirmasiPinjamanCDPage({super.key, this.idPengajuan});

  @override
  State<KonfirmasiPinjamanCDPage> createState() =>
      _KonfirmasiPinjamanCDPageState();
}

class _KonfirmasiPinjamanCDPageState extends State<KonfirmasiPinjamanCDPage>
    with DidChangeDependenciesStream, DisposeBagMixin {
  final LocalStorage storage = LocalStorage('todo_app.json');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as KonfirmasiPinjamanCDPage?;
    if (args != null) {
      context
          .bloc<KonfirmasiPincamanCdBloc>()
          .getPinjamanControl(args.idPengajuan!);
    }
  }

  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap(
            (_) => context.bloc<KonfirmasiPincamanCdBloc>().messageReqOtp)
        .exhaustMap(messageReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<KonfirmasiPincamanCdBloc>().message)
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
    final bloc = BlocProvider.of<KonfirmasiPincamanCdBloc>(context);
    final List<Widget> body = [
      KonfirmasiPinjamanCDDetail(ppBloc: bloc),
      OtpPrivyPinjamanCd(ppBloc: bloc),
      const LoadingDanain(),
      AcceptPinjamanCd(ppBloc: bloc)
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
    final bloc = BlocProvider.of<KonfirmasiPincamanCdBloc>(context);
    if (message is PenawaranPinjamanSuccessMessage) {
      bloc.stepControl(2);
    }

    if (message is PenawaranPinjamanErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> handleMessage(message) async* {
    final bloc = BlocProvider.of<KonfirmasiPincamanCdBloc>(context);
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
