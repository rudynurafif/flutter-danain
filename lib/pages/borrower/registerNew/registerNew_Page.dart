import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/registerNew/registerNew_bloc.dart';
import 'package:flutter_danain/pages/borrower/registerNew/registerNew_state.dart';
import 'package:flutter_danain/pages/borrower/registerNew/step/step_1.dart';
import 'package:flutter_danain/pages/borrower/registerNew/step/step_2.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class RegisterNewPage extends StatefulWidget {
  static const routeName = '/registrasi_borrower';
  const RegisterNewPage({super.key});

  @override
  State<RegisterNewPage> createState() => _RegisterNewPageState();
}

class _RegisterNewPageState extends State<RegisterNewPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );

  @override
  void initState() {
    // TODO: implement initState
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<RegisterNewBloc>().messageReqOtp)
        .exhaustMap(messageReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<RegisterNewBloc>().messageSendOtp)
        .exhaustMap(messageSendOtp)
        .collect()
        .disposedBy(bag);
    super.initState();
  }

  Stream<void> messageReqOtp(message) async* {
    print('message otp req $message');
    final registerLenderBloc = BlocProvider.of<RegisterNewBloc>(context);
    if (message is RegisterNewSuccessMessage) {
      registerLenderBloc.stepControl(2);
    }

    if (message is RegisterNewErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> messageSendOtp(message) async* {
    // print('message send req $message');
    final registerLenderBloc = BlocProvider.of<RegisterNewBloc>(context);
    if (message is RegisterNewSuccessMessage) {
      print('message send req $message');
    }

    if (message is RegisterNewErrorMessage) {
      registerLenderBloc.otpControlError(true);
      registerLenderBloc.stepControl(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerBorrower = BlocProvider.of<RegisterNewBloc>(context);
    final List<Widget> listWidget = [
      Step1RegisBorrower(regisBloc: registerBorrower),
      Step2RegisBorrower(regisBloc: registerBorrower),
    ];
    return StreamBuilder(
      stream: registerBorrower.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return listWidget[data - 1];
      },
    );
  }
}
