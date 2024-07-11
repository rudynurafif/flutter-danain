import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

import '../../../../domain/models/app_error.dart';
import '../../home/home_page.dart';
import '../components/pop_up_verifikasi_pendanaan.dart';
import '../components/validasi_pendanaan_lender.dart';
import '../new_pendanaan.dart';
import '../step_new_pendanaan/step_new_detail_pendanaan.dart';
import '../step_new_pendanaan/step_new_otp_pendanaan.dart';
import 'new_detail_pendanaan_bloc.dart';
import 'new_detail_pendanaan_state.dart';

class NewDetailPendanaanPage extends StatefulWidget {
  static const routeName = '/new_detail_pendanaan';

  const NewDetailPendanaanPage({super.key});

  @override
  State<NewDetailPendanaanPage> createState() => _NewDetailPendanaanPageState();
}

class _NewDetailPendanaanPageState extends State<NewDetailPendanaanPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    context.bloc<NewDetailPendanaanBloc>().getNewDetailPendanaan();

    context.bloc<NewDetailPendanaanBloc>().isPostDone.listen((event) {
      if (event == true) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          builder: (context) {
            return ModalValidasiPendanaan(
              status: 'Pendanaan Berhasil',
              description:
                  'Lihat peluang pendanaan lainnya atau cek riwayat pendanaan Anda di portofolio ',
              icon: 'assets/lender/pendanaan/check.svg',
              pendanaan: null,
              textButton: 'Lihat Pendanaan Lainnya',
              action1: () => Navigator.pushNamedAndRemoveUntil(context, NewPendanaanPage.routeName,
                  (route) => route.settings.name == NewPendanaanPage.routeName),
              textButton2: 'Lihat Portofolio',
              action2: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomePageLender.routeNeme,
                  (route) => false,
                  arguments: const HomePageLender(index: 1),
                );
              },
            );
          },
        );
      }
    });

    context.bloc<NewDetailPendanaanBloc>().messageCheckSaldo.listen(
          (value) => handleCheckSaldo(value),
        );
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<NewDetailPendanaanBloc>().messageCheckSaldo)
        .exhaustMap(handleMessageCheckSaldo)
        .collect()
        .disposedBy(bag);
  }

  Future<void> handleCheckSaldo(PendanaanMessage? value) async {}

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<NewDetailPendanaanBloc>();
    final List<Widget> listStepWidget = [
      StepNewDetailPendanaan(bloc: bloc),
      StepNewOtpPendanaan(bloc: bloc)
    ];
    return StreamBuilder<int>(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return WillPopScope(
          child: listStepWidget[data - 1],
          onWillPop: () async {
            switch (data) {
              case 1:
                Navigator.pop(context);
                break;
              case 2:
                bloc.stepControl(1);
                break;
              default:
            }
            return false;
          },
        );
      },
    );
  }

  Stream<void> handleMessageCheckSaldo(message) async* {
    if (message is PendanaanError) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(8),
          ),
        ),
        builder: (context) => balanceNotSufficient(context),
      );
    }

    final bloc = BlocProvider.of<NewDetailPendanaanBloc>(context);
    if (message is PendanaanSuccess) {
      bloc.reqOtpSubmit();
      bloc.stepControl(2);
    }
  }
}
