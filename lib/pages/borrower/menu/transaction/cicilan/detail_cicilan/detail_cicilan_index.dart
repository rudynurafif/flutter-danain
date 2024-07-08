import 'dart:convert';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_loading.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_state.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/step2/angsuran_list.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/step2/pembayaran_pending.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/step2/step_ambil_emas.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/step_1.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:localstorage/localstorage.dart';

import 'step2/pembayaran_non_pending.dart';

class DetailCicilanIndex extends StatefulWidget {
  static const routeName = '/detail_cicilan_emas';
  final int? idCicilan;
  const DetailCicilanIndex({super.key, this.idCicilan});

  @override
  State<DetailCicilanIndex> createState() => _DetailCicilanIndexState();
}

class _DetailCicilanIndexState extends State<DetailCicilanIndex>
    with DisposeBagMixin, DidChangeDependenciesStream {
  int idnya = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilanDetailBloc>().messageBatalkan)
        .exhaustMap(handleMessageBatalkan)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilanDetailBloc>().messageOtpReq)
        .exhaustMap(handleMessageRequest)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilanDetailBloc>().messageOtpValidate)
        .exhaustMap(handleValidate)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilanDetailBloc>().messagePaymentData)
        .exhaustMap(handlePayment)
        .collect()
        .disposedBy(bag);
  }

  @override
  void dispose() {
    context.bloc<CicilanDetailBloc>().dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as DetailCicilanIndex?;
    if (args != null) {
      context.bloc<CicilanDetailBloc>().getDataDetail(args.idCicilan!);
      setState(() {
        idnya = args.idCicilan!;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CicilanDetailBloc>(context);

    return RefreshIndicator(
      onRefresh: () async {
        return bloc.getDataDetail(idnya);
      },
      child: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            final status = data['status'];
            return StreamBuilder<int>(
              stream: bloc.stepStream$,
              builder: (context, snapshot) {
                final step = snapshot.data ?? 1;
                return WillPopScope(
                  child: bodyBuilder(step, status, bloc),
                  onWillPop: () async {
                    if (step == 1) {
                      Navigator.pop(context);
                    } else {
                      bloc.stepChange(step - 1);
                    }
                    return false;
                  },
                );
              },
            );
          }

          return Scaffold(
            appBar: previousTitle(context, 'Detail Cicil Emas'),
            body: const DetailCicilanLoading(),
          );
        },
      ),
    );
  }

  Stream<void> handleMessageBatalkan(message) async* {
    if (message is DetailCicilanSuccess) {
      await Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
          arguments: HomePage(index: 1, subIndex: 1),
          (route) => false);
    }

    if (message is DetailCicilanError) {
      // ignore: use_build_context_synchronously
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> handleMessageRequest(message) async* {
    final bloc = BlocProvider.of<CicilanDetailBloc>(context);
    if (message is DetailCicilanSuccess) {
      bloc.stepChange(2);
    }

    if (message is DetailCicilanError) {
      // ignore: use_build_context_synchronously
      context.showSnackBarError(message.message);
    }
    bloc.isLoadingButtonChange(false);
  }

  Stream<void> handleValidate(message) async* {
    final bloc = BlocProvider.of<CicilanDetailBloc>(context);
    final LocalStorage storage = LocalStorage('todo_app.json');
    if (message is DetailCicilanSuccess) {
      final data = storage.getItem('response_cicil');
      final dataBody = jsonDecode(data);
      print(dataBody);
      bloc.setResult(dataBody);
      bloc.stepChange(3);
    }
    if (message is DetailCicilanError) {
      context.showSnackBarError(message.message);
    }
    bloc.isLoadingButtonChange(false);
  }

  Stream<void> handlePayment(message) async* {
    final bloc = BlocProvider.of<CicilanDetailBloc>(context);
    final LocalStorage storage = LocalStorage('todo_app.json');
    if (message is DetailCicilanSuccess) {
      final data = storage.getItem('result_payment');
      bloc.setResult(data);
      bloc.stepChange(3);
    }
    if (message is DetailCicilanError) {
      context.showSnackBarError(message.message);
    }
    bloc.isLoadingButtonChange(false);
  }

  Widget bodyBuilder(int step, String statusTransaksi, CicilanDetailBloc bloc) {
    if (step == 1) {
      return Step1DetailCicilan(detailBloc: bloc);
    }
    if (step == 2 && statusTransaksi == 'Pending') {
      return PembayaranDetailPending(
        cicilBloc: bloc,
      );
    }
    if (step == 2 &&
        statusTransaksi != 'Pending' &&
        statusTransaksi != 'Lunas') {
      return AngsuranListPage(cicilBloc: bloc);
    }
    if (step == 2 && statusTransaksi == 'Lunas') {
      return StepAmbilEmas(cicilBloc: bloc);
    }

    if (step == 3) {
      return PembayaranDetail(cicilBloc: bloc);
    }
    return Container();
  }
}
