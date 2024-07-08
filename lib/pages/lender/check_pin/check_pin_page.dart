import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_page.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';

import '../../../widgets/form/pin.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';
import 'check_pin_bloc.dart';
import 'check_pin_state.dart';

class CheckPinLenderPage extends StatefulWidget {
  static const routeName = '/check_pin_lender_page';
  const CheckPinLenderPage({super.key});

  @override
  State<CheckPinLenderPage> createState() => _CheckPinLenderPageState();
}

class _CheckPinLenderPageState extends State<CheckPinLenderPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CheckPinLenderBloc>().pinMessage)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CheckPinLenderBloc>(context);
    return StreamBuilder<String?>(
      stream: bloc.pinErrorController,
      builder: (context, snapshot) {
        return PinWithForgotNoClose2(
          onChangePin: (value) {
            if (value.length == 6) {
              bloc.pinChange(value);
            }
            bloc.pinErrorChange(null);
          },
          onCompletePin: (value) {
            if (value.length == 6) {
              bloc.pinChange(value);
            }
          },
          isNavigate: true,
          actionNavigate: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginLenderPage.routeName,
              (_) => false,
            );
            bloc.logout();
          },
          errorPin: snapshot.data,
        );
      },
    );
  }

  Stream<void> handleMessage(message) async* {
    if (message is CheckPinSuccess) {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        HomePageLender.routeNeme,
        (route) => false,
      );
    }

    if (message is CheckPinError) {
      await showDialog(
        context: context,
        builder: (context) => const ModalPopUp(
          icon: 'assets/lender/home/payung2.svg',
          title: 'Maaf saat ini aplikasi sedang mengalami gangguan',
          message:
              'Harap tunggu beberapa saat untuk mengakses kembali aplikasi',
        ),
      );
    }

    if (message is CheckPinSalah10Menit) {
      await showDialog(
        context: context,
        builder: (context) => ModalPopUpNoClose(
          icon: 'assets/lender/home/payung2.svg',
          title: 'Anda lupa pin?',
          message:
              'Terdapat percobaan akses pin sebanyak 3 kali . Harap tunggu 10 menit sebelum coba kembali',
          actions: [
            Button2(
              btntext: 'Lupa Pin',
              color: HexColor(lenderColor),
              action: () {
                Navigator.pushNamed(context, LupaPinPage.routeName);
              },
            )
          ],
        ),
      );
    }
  }
}
