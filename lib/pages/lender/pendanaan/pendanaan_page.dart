import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/lender/setor_dana/setor_dana.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import 'pendanaan.dart';

class PendanaanPage extends StatefulWidget {
  static const routeName = '/pendanaan_lender_page';
  const PendanaanPage({super.key});

  @override
  State<PendanaanPage> createState() => _PendanaanPageState();
}

class _PendanaanPageState extends State<PendanaanPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    context.bloc<PendanaanBloc>().getDataBeranda();
    context.bloc<PendanaanBloc>().getProduct();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<PendanaanBloc>().messageCheckSaldo)
        .exhaustMap(handleMessageCheckSaldo)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<PendanaanBloc>().messageReqOtp)
        .exhaustMap(handleReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<PendanaanBloc>().messageValidateOtp)
        .exhaustMap(handleValidateOtp)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PendanaanBloc>(context);
    final List<Widget> listWidget = [
      StepPembuka(pBloc: bloc),
      StepDetailPendanaan(pBloc: bloc),
      DocumentStepPendanaan(pBloc: bloc),
      StepOtpPendanaan(bloc: bloc),
    ];
    return StreamBuilder<bool>(
      stream: bloc.isDetailStream,
      builder: (context, snapshot) {
        final isDetail = snapshot.data ?? false;
        return StreamBuilder<int>(
          stream: bloc.stepStream,
          builder: (context, snapshot) {
            final data = snapshot.data ?? 1;
            return WillPopScope(
              child: listWidget[data - 1],
              onWillPop: () async {
                switch (data) {
                  case 1:
                    Navigator.pop(context);
                    break;
                  case 2:
                    bloc.stepControl(1);
                    break;
                  case 3:
                    if (isDetail == true) {
                      bloc.stepControl(2);
                    } else {
                      bloc.stepControl(1);
                    }
                    break;
                  case 4:
                    bloc.stepControl(3);
                    break;
                  default:
                    break;
                }
                return false;
              },
            );
          },
        );
      },
    );
  }

  Stream<void> handleMessageCheckSaldo(message) async* {
    final bloc = BlocProvider.of<PendanaanBloc>(context);
    print('okebang');
    if (message is PendanaanSuccess) {
      bloc.stepControl(3);
    }

    if (message is PendanaanError) {
      await showDialog(
        context: context,
        builder: (context) => ModalPopUp(
          icon: 'assets/lender/pendanaan/saldo_not_enough.svg',
          title: 'Saldo Anda Tidak Cukup',
          message: 'Silakan lakukan Setor Dana sebelum melakukan pendanaan',
          actions: [
            Button2(
              btntext: 'Setor Dana',
              action: () {
                Navigator.popAndPushNamed(
                    context, SetorDanaLenderPage.routeName);
              },
              color: HexColor(lenderColor),
            )
          ],
        ),
      );
    }
  }

  Stream<void> handleReqOtp(message) async* {
    final bloc = BlocProvider.of<PendanaanBloc>(context);

    if (message is PendanaanSuccess) {
      bloc.stepControl(4);
    }

    if (message is PendanaanError) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> handleValidateOtp(message) async* {
    final bloc = BlocProvider.of<PendanaanBloc>(context);
    bloc.isLoadingChange(false);
    if (message is PendanaanSuccess) {
      await showDialog(
        context: context,
        builder: (context) => ModalPopUpCustomAction(
          icon: 'assets/lender/pendanaan/check.svg',
          title: 'Pendanaan Berhasil',
          message: 'Riwayat pendanaan dapat dilihat pada menu portofolio ',
          actions: [
            Button2(
              btntext: 'Lihat Pendanaan Lainnya',
              color: HexColor(lenderColor),
              action: () {
                Navigator.pop(context);
                bloc.detailControl(false);
                bloc.stepControl(1);
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    HomePage.routeName,
                    arguments: const HomePage(index: 1),
                  );
                },
                child: Subtitle2Extra(
                  text: 'Lihat Portofolio',
                  color: HexColor(lenderColor),
                ),
              ),
            ),
          ],
          callback: () {
            Navigator.pop(context);
            bloc.stepControl(1);
          },
        ),
      );
    }

    if (message is PendanaanError) {
      if (message.message.toLowerCase().contains('kode')) {
        bloc.errorOtpChange('Kode OTP yang dimasukkan tidak sesuai');
      } else {
        context.showSnackBarError(message.message);
      }
    }
  }
}
