import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import '../../pages/borrower/menu/profile/tab_menu/files/kebijakan_privasi_page.dart';
import '../../pages/borrower/menu/profile/tab_menu/files/syarat_ketentuan_page.dart';
import '../../pages/borrower/menu/profile/tab_menu/info_bank/info_bank_page.dart';
import '../../pages/borrower/menu/profile/tab_menu/info_pribadi/info_page.dart';
import '../../pages/borrower/menu/profile/tab_menu/settings/settings_page.dart';

class ListTabs extends StatelessWidget {
  final HomeBloc homeBloc;
  final Map<String, dynamic> dataHome;

  const ListTabs(BuildContext context, {super.key, required this.homeBloc, required this.dataHome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          checkIsVerifikasi(context),
          checkBank(context),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, SettingPageBorrower.routeName);
            },
            child: tabContentBorrower(
              context,
              'assets/images/icons/profile/settings.svg',
              'Pengaturan Akun',
              true,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, SyaratKetentuan.routeName);
            },
            child: tabContentBorrower(
              context,
              'assets/images/icons/profile/syarat.svg',
              'Syarat dan Ketentuan',
              true,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, KebijakanPrivasiPage.routeName);
            },
            child: tabContentBorrower(
              context,
              'assets/images/icons/profile/privasi.svg',
              'Kebijakan Privasi',
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget checkIsVerifikasi(BuildContext context) {
    final int status = dataHome['status']['aktivasi_status'];
    if (status == 10) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushNamed(
            context,
            InfoBorrowerPage.routeName,
          );
        },
        child: tabContentBorrower(
          context,
          'assets/images/icons/profile/person.svg',
          'Informasi Pribadi',
          true,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget checkBank(BuildContext context) {
    final bool bankStatus = dataHome['status']['bank'];
    if (bankStatus == true) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, InfoBankPage.routeName);
        },
        behavior: HitTestBehavior.opaque,
        child: tabContentBorrower(
          context,
          'assets/images/icons/profile/credit_card.svg',
          'Informasi Akun Bank',
          true,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
