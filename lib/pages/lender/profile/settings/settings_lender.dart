import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/ubah_password/ubah_password.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin.dart';
import 'package:flutter_danain/widgets/template/tab.dart';

class SettingsLender extends StatelessWidget {
  static const routeName = '/settings_lender';
  const SettingsLender({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Pengaturan Akun'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, ChangePasswordPage.routeName);
              },
              child: tabContentLender(
                context,
                'assets/images/icons/profile/password.svg',
                'Ubah Kata Sandi',
                true,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, UbahPinLenderPage.routeName);
              },
              child: tabContentLender(
                context,
                'assets/images/icons/profile/password.svg',
                'Ubah Pin',
                true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
