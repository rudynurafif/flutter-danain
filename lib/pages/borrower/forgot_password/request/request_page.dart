import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/forgot_password_state.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/request_bloc.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/step_1.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/step_2.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

class ReqKodeForgotPassword extends StatefulWidget {
  static const routeName = '/req_forgot_password';
  const ReqKodeForgotPassword({super.key});

  @override
  State<ReqKodeForgotPassword> createState() => _ReqKodeForgotPasswordState();
}

class _ReqKodeForgotPasswordState extends State<ReqKodeForgotPassword>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void didChangeDependencies() {
    didChangeDependencies$
        .exhaustMap(
            (_) => context.bloc<ForgotPasswordEmailBloc>().messageStream)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ForgotPasswordEmailBloc>(context);
    final List<Widget> widgetList = [
      Step1ForgotPassword(fpBloc: bloc),
      Step2ForgotPassword(fpBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return widgetList[data - 1];
      },
    );
  }

  Stream<void> handleMessage(message) async* {
    final bloc = BlocProvider.of<ForgotPasswordEmailBloc>(context);
    if (message is ForgotPasswordSuccessMessage) {
      bloc.stepControl(2);
      context.showSnackBarSuccess('Email Terkirim');
    }

    if (message is ForgotPasswordErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }
}
