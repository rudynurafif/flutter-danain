import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/email_deeplink/email_deeplink_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/login/login_page.dart';
import 'package:flutter_danain/utils/constants.dart';
import 'package:flutter_danain/utils/string_ext.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class EmailSuccessScreen extends StatefulWidget {
  final EmailDeepLinkBloc bloc;
  const EmailSuccessScreen({
    super.key,
    required this.bloc,
  });

  @override
  State<EmailSuccessScreen> createState() => _EmailSuccessScreenState();
}

class _EmailSuccessScreenState extends State<EmailSuccessScreen> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
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
            const Subtitle2(
              text:
                  'Selamat! email berhasil diverifikasi. Segera lengkapi pendaftaran dan mulailah mengeksplorasi semua layanan menarik kami.',
              color: Color(0xff777777),
              align: TextAlign.center,
            ),
            const SizedBox(height: 54),
            buttonBuilder(widget.bloc),
          ],
        ),
      ),
    );
  }

  Widget buttonBuilder(EmailDeepLinkBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.isLogin,
      builder: (context, snapshot) {
        final isLogin = snapshot.data ?? false;
        if (isLogin == true) {
          return Column(
            children: [
              Button1(
                btntext: 'Lengkapi Data Diri',
                action: () {
                  const message =
                      'Ini menyusul ges page nya belom ada, taro aja di notes takut lupa';
                  message.toToastError(context);
                },
              ),
              const SizedBox(height: 20),
              Button1(
                btntext: 'Masuk Ke Menu Utama',
                color: Colors.white,
                textcolor: Constants.get.borrowerColor,
                action: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomePage.routeName,
                    (route) => false,
                  );
                },
              )
            ],
          );
        }
        return Button1(
          btntext: 'Kembali ke Menu Utama',
          action: () {
            rxPrefs.clear();
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPage.routeName,
              (route) => false,
            );
          },
        );
      },
    );
  }
}
