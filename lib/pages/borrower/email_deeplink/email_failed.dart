import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/login/login.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class EmailFailedScreen extends StatefulWidget {
  const EmailFailedScreen({super.key});

  @override
  State<EmailFailedScreen> createState() => _EmailFailedScreenState();
}

class _EmailFailedScreenState extends State<EmailFailedScreen> {
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
            SvgPicture.asset('assets/images/register/expired.svg'),
            const SizedBox(height: 24),
            const Headline2(text: 'Link Sudah Tidak Aktif'),
            const SizedBox(height: 8),
            const Subtitle2(
              text:
                  'Gagal masuk ke halaman tujuan karena link sudah tidak aktif',
              color: Color(0xff777777),
              align: TextAlign.center,
            ),
            const SizedBox(height: 54),
            Button1(
              btntext: 'Kembali ke Menu Utama',
              action: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return ModalPopUp(
                      icon: 'assets/images/icons/warning_red.svg',
                      title: 'Verifikasi Email',
                      message:
                          'Silakan masuk ke akun Anda untuk melakukan verifikasi email',
                      actions: [
                        ButtonWidget(
                          title: 'Masuk',
                          onPressed: () {
                            rxPrefs.clear();
                            Navigator.pop(dialogContext);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginPage.routeName,
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
