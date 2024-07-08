import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_PreviousHelp.dart';
import 'package:flutter_danain/pages/borrower/auxpage/emailVerificationSuccess/email_status_verif_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EmailStatusVerif extends StatefulWidget {
  static const routeName = '/emailStatusVerifs';
  final int? status;

  EmailStatusVerif({Key? key, this.status}) : super(key: key);

  @override
  State<EmailStatusVerif> createState() => _EmailStatusVerifState();
}

class _EmailStatusVerifState extends State<EmailStatusVerif> with DidChangeDependenciesStream, DisposeBagMixin{
  int statusNumber = 1;
  late EmailStatusVerifBloc emailStatusBloc;

  @override
  void initState() {
    super.initState();
    emailStatusBloc = BlocProvider.of<EmailStatusVerifBloc>(context);
    emailStatusBloc.setBeranda();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<EmailStatusVerifBloc>().messageBeranda$)
        .exhaustMap(validationBeranda)
        .collect()
        .disposedBy(bag);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)?.settings.arguments as EmailStatusVerif?;
    if (args != null && args.status != null) {
      setState(() {
        statusNumber = args.status!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousHelpWidget(context),
      body:  successScreen(context),
    );
  }
}
Stream<void> validationBeranda(response) async* {
  print('validation beranda');
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.remove('token_sementara');
  // await prefs.remove('step_sementara');
  // await prefs.remove('beranda_sementara');
  print(response);
  await delay(1000);
}


Widget successScreen(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(24),
    margin: EdgeInsets.only(top: 60),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/register/change_email.svg'),
          SizedBox(height: 24),
          Headline2(text: 'Verifikasi Email Berhasil'),
          SizedBox(height: 8),
          Subtitle2(
            text:
            'Selamat! email berhasil diverifikasi. Segera lengkapi pendaftaran dan mulailah mengeksplorasi semua layanan menarik kami.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          ),
          SizedBox(height: 54),
          Button1(
            btntext: 'Lengkapi Data Diri',
            action: () {
              print("Resend varification email");
            },
          ),
          SizedBox(height: 20),
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

Widget expiredScreen(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(24),
    margin: EdgeInsets.only(top: 60),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/register/expired.svg'),
          SizedBox(height: 24),
          Headline2(text: 'Link Sudah Tidak Aktif'),
          SizedBox(height: 8),
          Subtitle2(
            text: 'Gagal masuk ke halaman tujuan karena link sudah tidak aktif',
            color: HexColor('#777777'),
            align: TextAlign.center,
          ),
          SizedBox(height: 54),
          Button1(
            btntext: 'Kembali ke Menu Utama',
            action: () {
              print("back");
            },
          ),
        ],
      ),
    ),
  );
}

