import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/settings_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class DeepLinkPage extends StatefulWidget {
  static const routeName = '/deeplink_email_page';

  const DeepLinkPage({Key? key}) : super(key: key);

  @override
  State<DeepLinkPage> createState() => _DeepLinkPageState();
}

class _DeepLinkPageState extends State<DeepLinkPage> {
  final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());

  @override
  void initState() {
    super.initState();
    showAlertNotification();
  }

  void showAlertNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => ModalPopUp(
          icon: 'assets/images/icons/check.svg',
          title: 'Pengajuan Perubahan Email Berhasil Dikirim',
          message:
              'Proses verifikasi data memerlukan waktu kurang lebih 1x24 jam',
          actions: [
            Button2(
              btntext: 'Selesai',
              action: () {
                Navigator.popAndPushNamed(
                    context, SettingPageBorrower.routeName);
              },
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: previousCustomWidget(context, () {
          Navigator.pushNamed(context, SettingPageBorrower.routeName);
        }),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 97),
              SvgPicture.asset('assets/images/forgot_password/send_email.svg'),
              const SizedBox(height: 24),
              const Headline2(text: 'Cek Email Anda'),
              const SizedBox(height: 8),
              FutureBuilder(
                future: rxPrefs.getString('email_baru'),
                builder: (context, snapshot) {
                  final data = snapshot.data ?? 'Email anda';
                  return Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Link verifikasi telah dikirim ke ',
                          style: TextStyle(
                            color: Color(0xff777777),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '$data.',
                          style: const TextStyle(
                            color: Color(0XFF333333),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' Segera cek email dan klik tombol “Verifikasi email” untuk melanjutkan proses perubahan email.',
                          style: TextStyle(
                            color: Color(0xff777777),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 40),
              Button1(
                btntext: 'Kembali ke halaman Pengaturan Akun',
                action: () {
                  Navigator.pushNamed(context, SettingPageBorrower.routeName);
                },
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        await Navigator.pushNamed(context, SettingPageBorrower.routeName);
        return false;
      },
    );
  }
}
