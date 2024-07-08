import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/step/data_alamat.dart';
import 'package:flutter_danain/pages/lender/verifikasi/step/data_diri_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/step/data_pribadi_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/step/pengisian_data_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/step/step_done.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_bloc.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_state.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

class VerifikasiPage extends StatefulWidget {
  static const routeName = '/verifikasi_page';
  const VerifikasiPage({super.key});

  @override
  State<VerifikasiPage> createState() => _VerifikasiPageState();
}

class _VerifikasiPageState extends State<VerifikasiPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    context.bloc<VerifikasiBloc>().getProvinsi();
    context.bloc<VerifikasiBloc>().getPekerjaan();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<VerifikasiBloc>().messageVerif)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
  }

  Widget _bodyBuilder(BuildContext context, int data, VerifikasiBloc bloc) {
    switch (data) {
      case 0:
        return DataDiriPage(verifBloc: bloc);
      case 1:
        return PengisianDataPage(verifBloc: bloc);
      case 2:
        return DataPribadiPage(verifBloc: bloc);
      case 3:
        return StepDataAlamat(verifBloc: bloc);
      case 4:
        return StepDoneVerifikasi(verifBloc: bloc);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VerifikasiBloc>(context);
    return StreamBuilder(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 0;
        return Scaffold(
          body: WillPopScope(
            child: _bodyBuilder(context, data, bloc),
            // child: Step3Verif(stepBloc: _stepBloc),
            onWillPop: () async {
              if (data == 0) {
                Navigator.pop(context);
              } else if (data == 4) {
                Navigator.pushNamed(context, HomePageLender.routeNeme);
              } else {
                bloc.stepControl(data - 1);
              }
              return false;
            },
          ),
        );
      },
    );
  }

  Stream<void> handleMessage(message) async* {
    final bloc = BlocProvider.of<VerifikasiBloc>(context);
    if (message is VerifikasiSuccessMessage) {
      bloc.stepControl(4);
    }

    if (message is VerifikasiErrorMessage) {
      unawaited(showDialog(
        context: context,
        builder: (context) {
          return ModalPopUp(
            icon: 'assets/images/icons/warning_red.svg',
            title: 'Sepertinya terjadi kesalahan',
            message: message.message,
          );
        },
      ));
    }
  }
}
