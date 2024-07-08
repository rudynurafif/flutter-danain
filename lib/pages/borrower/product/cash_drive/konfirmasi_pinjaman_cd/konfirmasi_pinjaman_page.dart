import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_state.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/step/konfirmasi_accept_pinjaman.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/step/konfirmasi_otp_privy.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/step/konfirmasi_pinjaman_detail.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/step/konfrimasi_pinjaman_qrcode.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:localstorage/localstorage.dart';

class KonfirmasiPinjamanPage extends StatefulWidget {
  static const routeName = '/konfirmasi_pinjaman_cnd';
  final int? idPengajuan;
  final int? idTaskPengajuan;
  final int? isStep;
  final Map<String, dynamic>? Data;
  const KonfirmasiPinjamanPage(
      {super.key,
      this.idPengajuan,
      this.idTaskPengajuan,
      this.isStep,
      this.Data});

  @override
  State<KonfirmasiPinjamanPage> createState() => _PenawaranPinjamanPageState();
}

class _PenawaranPinjamanPageState extends State<KonfirmasiPinjamanPage>
    with DidChangeDependenciesStream, DisposeBagMixin {
  final LocalStorage storage = LocalStorage('todo_app.json');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as KonfirmasiPinjamanPage?;
    if (args != null) {
      context
          .bloc<KonfirmasiPinjamanBloc2>()
          .getPinjamanControl(args.idPengajuan!);
      context
          .bloc<KonfirmasiPinjamanBloc2>()
          .idPengajuanControl(args.idPengajuan!);
      context
          .bloc<KonfirmasiPinjamanBloc2>()
          .idTakControl(args.idTaskPengajuan!);
      if (args.isStep != null) {
        context.bloc<KonfirmasiPinjamanBloc2>().stepControl(args.isStep!);
      }
      context.bloc<KonfirmasiPinjamanBloc2>().responseChange(args.Data);
    }
  }

  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap(
            (_) => context.bloc<KonfirmasiPinjamanBloc2>().messageReqOtp)
        .exhaustMap(messageReqOtp)
        .collect()
        .disposedBy(bag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<KonfirmasiPinjamanBloc2>(context);
    final List<Widget> body = [
      KonfirmasiPinjamanDetail(ppBloc: bloc),
      KonfirmasiOtpPrivyPinjaman(ppBloc: bloc),
      const LoadingDanain(),
      KonfirmasiAcceptPinjaman(ppBloc: bloc),
      KonfirmasiPinjamanQrCodePage(ppBloc: bloc)
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
    final bloc = BlocProvider.of<KonfirmasiPinjamanBloc2>(context);
    if (message is KonfirmasiPinjamanSuccessMessage) {
      print('otp berhasil');
      bloc.stepControl(2);
    }

    if (message is KonfirmasiPinjamanErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }
}
