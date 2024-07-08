import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_bloc.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_state.dart';
import 'package:flutter_danain/pages/lender/rdl/step/step_alamat.dart';
import 'package:flutter_danain/pages/lender/rdl/step/step_data_diri.dart';
import 'package:flutter_danain/pages/lender/rdl/step/step_done.dart';
import 'package:flutter_danain/pages/lender/rdl/step/step_loading.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

class RegisRdlPage extends StatefulWidget {
  static const routeName = '/regis_rdl_page';
  const RegisRdlPage({super.key});

  @override
  State<RegisRdlPage> createState() => _RegisRdlPageState();
}

class _RegisRdlPageState extends State<RegisRdlPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    context.bloc<RegisRdlBloc>().initGetMaster();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<RegisRdlBloc>().messageVerif)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<RegisRdlBloc>();
    final List<Widget> listWidget = [
      StepDataPribadiRDL(rdlBloc: bloc),
      StepAlamatRdl(rdlBloc: bloc),
      StepDoneRegisRdl(rdlBloc: bloc),
    ];
    return StreamBuilder<bool>(
      stream: bloc.isLoading,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? true;
        if (isLoading == true) {
          return const StepLoadingRdl();
        }
        return StreamBuilder<int>(
          stream: bloc.stepStream,
          builder: (context, snapshot) {
            final step = snapshot.data ?? 1;
            return WillPopScope(
              child: listWidget[step - 1],
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
      },
    );
  }

  Stream<void> handleMessage(message) async* {
    final bloc = BlocProvider.of<RegisRdlBloc>(context);
    if (message is RegisRdlSuccessMessage) {
      bloc.stepChange(3);
    }

    if (message is RegisRdlErrorMessage) {
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
