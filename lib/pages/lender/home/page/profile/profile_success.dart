import 'package:flutter/material.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/files/syarat_ketentuan_page.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman.page.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/profile/info/info_data.dart';
import 'package:flutter_danain/pages/lender/profile/info_bank/info_bank_lender_page.dart';
import 'package:flutter_danain/pages/lender/profile/settings/settings_lender.dart';
import 'package:flutter_danain/utils/constants.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../borrower/menu/profile/tab_menu/files/kebijakan_privasi_page.dart';

class ProfileLenderSuccess extends StatefulWidget {
  final HomeLenderBloc homeBloc;
  final User user;
  final Map<String, dynamic> dataHome;
  const ProfileLenderSuccess({
    super.key,
    required this.homeBloc,
    required this.user,
    required this.dataHome,
  });

  @override
  State<ProfileLenderSuccess> createState() => _ProfileLenderSuccessState();
}

class _ProfileLenderSuccessState extends State<ProfileLenderSuccess> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.homeBloc;
    return Parent(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: false,
          title: 'Profil',
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpacerV(value: 24),
            avatarProfile(
              statusAktivasi: widget.dataHome['status']['Aktivasi'] ?? 0,
            ),
            const SpacerV(value: 24),
            const DividerWidget(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: section1(
                statusBank: widget.dataHome['status']['bank'],
                statusAktivasi: widget.dataHome['status']['Aktivasi'] ?? 0,
              ),
            ),
            const DividerWidget(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: section2(),
            ),
            const DividerWidget(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  bloc.logout();
                },
                child: tabContentLender(
                  context,
                  'assets/images/icons/profile/logout.svg',
                  'Keluar',
                  false,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget avatarProfile({
    required int statusAktivasi,
  }) {
    final user = widget.user;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/lender/profile/icon_user.svg',
            width: 60,
            height: 60,
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline3(text: user.username),
              const SizedBox(height: 8),
              statusAccountControl(status: statusAktivasi),
            ],
          )
        ],
      ),
    );
  }

  Widget section1({
    required int statusBank,
    required int statusAktivasi,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (statusBank == 0)
          Container(
            margin: const EdgeInsets.only(top: 24),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                borderRadius: BorderRadius.circular(4),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle2Large(
                          text: 'Lengkapi Informasi Akun Bank ',
                          color: HexColor('#333333'),
                        ),
                        const SizedBox(height: 4),
                        Subtitle4(
                          text:
                              'Akun bank Anda diperlukan untuk melakukan transaksi penarikan dana',
                          color: HexColor('#777777'),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              InfoBankLenderPage.routeName,
                              arguments: InfoBankLenderPage(
                                username: widget.user.username,
                                action: 'create',
                              ),
                            );
                          },
                          child: Subtitle3(
                            text: 'Lengkapi Sekarang >',
                            color: Constants.get.lenderColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset('assets/lender/profile/complete_bank.svg')
              ],
            ),
          ),
        if (statusAktivasi == 1 || statusBank != 0)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, InfoDataLender.routeName);
            },
            child: tabContentLender(
              context,
              'assets/images/icons/profile/person.svg',
              'Informasi Pribadi',
              true,
            ),
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamed(context, SettingsLender.routeName);
          },
          child: tabContentLender(
            context,
            'assets/images/icons/profile/settings.svg',
            'Pengaturan Akun',
            true,
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamed(context, AjakTemanPage.routeName);
          },
          child: tabContentLender(
            context,
            'assets/lender/profile/add_user.svg',
            'Ajak Teman',
            true,
          ),
        ),
      ],
    );
  }

  Widget section2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamed(context, SyaratKetentuan.routeName);
          },
          child: tabContentLender(
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
          child: tabContentLender(
            context,
            'assets/images/icons/profile/privasi.svg',
            'Kebijakan Privasi',
            false,
          ),
        ),
      ],
    );
  }

  Widget statusAccountControl({
    required int status,
  }) {
    switch (status) {
      case 1:
        return statusAccountLender(
          image: 'assets/images/verification/verif.svg',
          content: 'Akun terverifikasi',
          bgColor: '#F5F9F6',
          color: '#27AE60',
        );
      case 11:
        return statusAccountLender(
          image: 'assets/images/verification/not_verif.svg',
          content: 'Akun tidak terverifikasi',
          bgColor: '#F6EBEB',
          color: '#EB5757',
        );
      case 12:
        return statusAccountLender(
          image: 'assets/images/verification/not_verif.svg',
          content: 'Akun tidak terverifikasi',
          bgColor: '#F6EBEB',
          color: '#EB5757',
        );
      case 0:
        return statusAccountLender(
          image: 'assets/images/verification/unverif.svg',
          content: 'Akun Belum terverifikasi',
          bgColor: '#F5F9F6',
          color: '#999999',
        );
      case 9:
        return statusAccountLender(
          image: 'assets/images/verification/unverif.svg',
          content: 'Akun Belum terverifikasi',
          bgColor: '#F5F9F6',
          color: '#999999',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget statusAccountLender({
    required String image,
    required String content,
    required String bgColor,
    required String color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: ShapeDecoration(
        color: HexColor(bgColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(image),
          const SizedBox(width: 5),
          Subtitle4(
            text: content,
            color: HexColor(color),
          )
        ],
      ),
    );
  }
}
