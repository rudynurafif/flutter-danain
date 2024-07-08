import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_PreviousHelp.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class EmailStatusVerifSuccess extends StatefulWidget {
  static const routeName = '/emailStatusVerifLender';
  final int? status;

  EmailStatusVerifSuccess({Key? key, this.status}) : super(key: key);

  @override
  State<EmailStatusVerifSuccess> createState() =>
      _EmailStatusVerifSuccessState();
}

class _EmailStatusVerifSuccessState extends State<EmailStatusVerifSuccess>
    with DidChangeDependenciesStream, DisposeBagMixin {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  void initState() {
    rxPrefs.remove('step_sementara');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: previousHelpWidget(context),
        body: successScreen(context),
      ),
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
          SvgPicture.asset('assets/lender/onboarding/gmail_success.svg'),
          const SizedBox(height: 24),
          const Headline2(text: 'Verifikasi Email Berhasil'),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Selamat! email berhasil diverifikasi. Segera lengkapi pendaftaran dan mulailah mengeksplorasi semua layanan menarik kami.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Button1(
            btntext: 'Masuk ke Menu Utama',
            color: HexColor(lenderColor),
            textcolor: HexColor('#FFFFFF'),
            action: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.routeName,
                (route) => false,
              );
            },
          )
        ],
      ),
    ),
  );
}

Widget expiredScreen(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.only(top: 60),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/register/expired.svg'),
          const SizedBox(height: 24),
          const Headline2(text: 'Link Sudah Tidak Aktif'),
          const SizedBox(height: 8),
          Subtitle2(
            text: 'Gagal masuk ke halaman tujuan karena link sudah tidak aktif',
            color: HexColor('#777777'),
            align: TextAlign.center,
          ),
          const SizedBox(height: 54),
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
