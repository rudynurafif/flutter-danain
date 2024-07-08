import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_PreviousHelp.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/fill_personal_data_page.dart';
import 'package:flutter_danain/pages/borrower/auxpage/emailVerificationSuccess/email_status_verif_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';


class EmailStatusVerifSuccessBorrower extends StatefulWidget {
  static const routeName = '/emailStatusVerifBorrower';
  final int? status;

  EmailStatusVerifSuccessBorrower({Key? key, this.status}) : super(key: key);

  @override
  State<EmailStatusVerifSuccessBorrower> createState() => _EmailStatusVerifSuccessBorrowerState();
}

class _EmailStatusVerifSuccessBorrowerState extends State<EmailStatusVerifSuccessBorrower> with DidChangeDependenciesStream, DisposeBagMixin{

  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  void initState() {
    super.initState();
    final emailStatusBloc = BlocProvider.of<EmailStatusVerifBloc>(context);
    emailStatusBloc.setBeranda();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<EmailStatusVerifBloc>().messageBeranda$)
        .exhaustMap(validationBeranda)
        .collect()
        .disposedBy(bag);

  }
  Stream<void> validationBeranda(response) async* {
    print('validation beranda');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_sementara');
    await prefs.remove('step_sementara');
    await prefs.remove('beranda_sementara');
    print(response);
    await delay(1000);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousHelpWidget(context),
      body: successScreen(context),
    );
  }
}



Widget successScreen(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.only(top: 60),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/register/change_email.svg'),
          const SizedBox(height: 24),
          const Headline2(text: 'Verifikasi Email Berhasil'),
          const SizedBox(height: 8),
          Subtitle2(
            text:
            'Selamat! email berhasil diverifikasi. Segera lengkapi pendaftaran dan mulailah mengeksplorasi semua layanan menarik kami.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          ),
          const SizedBox(height: 54),
          Button1(
            btntext: 'Lengkapi Data Diri',
            action: () {
              Navigator.pushNamedAndRemoveUntil(context, FillPersonalDataPage.routeName, (route) => false);

            },
          ),
          const SizedBox(height: 20),
          Button1(
            btntext: 'Masuk Ke Menu Utama',
            color: Colors.white,
            textcolor: HexColor(primaryColorHex),
            action: () {
              Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
            },
          )
        ],
      ),
    ),
  );
}

