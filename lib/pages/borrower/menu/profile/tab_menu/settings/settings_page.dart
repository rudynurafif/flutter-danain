import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/settings_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/tutup_akun_index.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/ubah_hp_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/ubah_password/ubah_password.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class SettingPageBorrower extends StatefulWidget {
  static const routeName = '/settings_borrower';
  const SettingPageBorrower({super.key});

  @override
  State<SettingPageBorrower> createState() => _SettingPageBorrowerState();
}

class _SettingPageBorrowerState extends State<SettingPageBorrower> {
  Map<String, dynamic> dataHome = {};
  bool pekerjaan = false;
  int status = 0;
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SettingsBloc>(context);
    return Scaffold(
      appBar: previousTitleCustom(
        context,
        'Pengaturan Akun',
        () async {
          await Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.routeName,
            arguments: const HomePage(index: 3),
            (route) => false,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkIsVerif(bloc),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushNamed(context, ChangePasswordPage.routeName);
                },
                child: tabContentBorrower(
                  context,
                  'assets/images/icons/profile/password.svg',
                  'Ubah Kata Sandi',
                  true,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushNamed(context, TutupAkunIndex.routeName);
                },
                child: tabContentBorrower(
                  context,
                  'assets/images/icons/profile/close_acc.svg',
                  'Tutup Akun',
                  true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget checkIsVerif(SettingsBloc bloc) {
    return StreamBuilder<Result<AuthenticationState>?>(
      stream: bloc.authState$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final beranda = data.orNull()?.userAndToken?.beranda;
          if (beranda != null) {
            final Map<String, dynamic> decodedToken =
                JwtDecoder.decode(beranda);
            dataHome = decodedToken['beranda'] ?? {};
            pekerjaan = dataHome['status']['pekerjaan'];
            status = dataHome['status']['aktivasi_status'];
          }

          if (pekerjaan == true && status == 10) {
            return Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      UbahHpPage.routeName,
                    );
                  },
                  child: tabContentBorrower(
                    context,
                    'assets/images/icons/faq/icon_7.svg',
                    'Ubah Nomor Handphone',
                    true,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      UbahEmailPage.routeName,
                    );
                  },
                  child: tabContentBorrower(
                    context,
                    'assets/images/icons/profile/email.svg',
                    'Ubah Alamat Email',
                    true,
                  ),
                ),
              ],
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
