import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/settings_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/step/step_1.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/step/step_2.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

import '../../../../../../../widgets/widget_element.dart';

class UpdateHpPage extends StatefulWidget {
  static const routeName = '/update_hp';
  final String? deepLink;
  const UpdateHpPage({super.key, this.deepLink});

  @override
  State<UpdateHpPage> createState() => _UpdateHpPageState();
}

class _UpdateHpPageState extends State<UpdateHpPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<UpdateHpBloc>().messageReqOtp)
        .exhaustMap(messageReqOtp)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<UpdateHpBloc>().messageValidasiOtp)
        .exhaustMap(messageValidasiOtp)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final hpBloc = BlocProvider.of<UpdateHpBloc>(context);
    final args = ModalRoute.of(context)?.settings.arguments as UpdateHpPage?;
    if (args != null && args.deepLink != null) {
      final uri = Uri.parse(args.deepLink!);

      final kode = uri.queryParameters['kode'];
      print('on page uri $kode');

      hpBloc.kodeControl(kode!);
    }
    return StreamBuilder<Result<AuthenticationState>?>(
      stream: hpBloc.authState,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (snapshot.hasData) {
          return SizedBox(
            child: data?.fold(
              ifLeft: (value) {
                return bodyError();
              },
              ifRight: (value) {
                return bodyBuilder(value.userAndToken!, hpBloc);
              },
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Stream<void> messageReqOtp(message) async* {
    print('message otp req $message');
    final hpBloc = BlocProvider.of<UpdateHpBloc>(context);
    if (message is UpdateHpSuccessMessage) {
      hpBloc.stepControl(2);
    }

    if (message is UpdateHpErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> messageValidasiOtp(message) async* {
    // final hpBloc = BlocProvider.of<UpdateHpBloc>(context);
    if (message is UpdateHpSuccessMessage) {
      await showDialog(
        context: context,
        builder: (context) => ModalPopUp(
          icon: 'assets/images/icons/check.svg',
          title: 'Pengajuan Perubahan No. Handphone Berhasil Dikirim',
          message:
              'Proses verifikasi data Anda memerlukan waktu kurang lebih 1x24 jam',
          actions: [
            Button2(
              btntext: 'Selesai',
              action: () {
                Navigator.popAndPushNamed(
                    context, SettingPageBorrower.routeName);
              },
            )
          ],
        ),
      );
    }

    if (message is UpdateHpErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Widget bodyError() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: const Subtitle1(
        text: 'Anda Belum login silakan login ulang',
      ),
    );
  }

  Widget bodyBuilder(UserAndToken userToken, UpdateHpBloc hpBloc) {
    return StreamBuilder(
      stream: hpBloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        switch (data) {
          case 1:
            return Step1UpdateHp(hpBloc: hpBloc);
          case 2:
            return Step2UpdateHp(hpBloc: hpBloc);
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
