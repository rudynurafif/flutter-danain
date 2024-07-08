import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/have_ubah_email.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/step/step_1.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/step/step_2.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/step/step_4.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'step/step_3.dart';

class UbahEmailPage extends StatefulWidget {
  static const routeName = '/ubah_emal';
  final bool? isDeepLink;
  const UbahEmailPage({super.key, this.isDeepLink});

  @override
  State<UbahEmailPage> createState() => _UbahEmailPageState();
}

class _UbahEmailPageState extends State<UbahEmailPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  bool isClickDeepLink = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as UbahEmailPage?;
    if (args != null && args.isDeepLink != null) {
      setState(() {
        isClickDeepLink = args.isDeepLink!;
      });
    }
  }

  @override
  void initState() {
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<UbahEmailBloc>().messageChangeEmail)
        .exhaustMap(messageChangeEmail)
        .collect()
        .disposedBy(bag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailBloc = BlocProvider.of<UbahEmailBloc>(context);

    if (isClickDeepLink) {
      return Step4UbahEmail(
        ubahBloc: emailBloc,
        isDeepLink: isClickDeepLink,
      );
    } else {
      Map<String, dynamic> dataBeranda = {};
      UserAndToken? userToken;
      return StreamBuilder(
        stream: emailBloc.authState,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data!.map((value) {
              dataBeranda = JwtDecoder.decode(value.userAndToken!.beranda);
              userToken = value.userAndToken!;
            });
            if (dataBeranda['beranda']['status']['status_request_email'] ==
                'waiting') {
              return HaveUbahEmail(
                userToken: userToken!,
              );
            }
            return bodyBuilder(emailBloc);
          } else {
            return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  Widget bodyBuilder(UbahEmailBloc emailBloc) {
    return StreamBuilder<int>(
      stream: emailBloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        switch (data) {
          case 1:
            return Step1UbahEmail(ubahBloc: emailBloc);
          case 2:
            return Step2UpdateEmail(emailBloc: emailBloc);
          case 3:
            return Step3UpdateEmail(emailBloc: emailBloc);
          case 4:
            return Step4UbahEmail(
              ubahBloc: emailBloc,
              isDeepLink: isClickDeepLink,
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Stream<void> messageChangeEmail(message) async* {
    final emailBloc = BlocProvider.of<UbahEmailBloc>(context);
    if (message is UpdateEmailSuccessMessage) {
      emailBloc.stepControl(4);
    }

    if (message is UpdateEmailErrorMessage) {
      print(message.message);
      context.showSnackBarError(message.message);
    }
  }
}
