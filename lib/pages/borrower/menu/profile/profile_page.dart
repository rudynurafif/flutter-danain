import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/onesignal.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/pages/borrower/after_login/complete_data/complete_data_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/fill_personal_data_page.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/files/kebijakan_privasi_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/files/syarat_ketentuan_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/info_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/settings_page.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ProfilePageBorrower extends StatefulWidget {
  final HomeBloc homeBloc;

  const ProfilePageBorrower({super.key, required this.homeBloc});

  @override
  State<ProfilePageBorrower> createState() => _ProfilePageBorrowerState();
}

class _ProfilePageBorrowerState extends State<ProfilePageBorrower>
    with DidChangeDependenciesStream, DisposeBagMixin {
  Map<String, dynamic> dataHome = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.homeBloc.setBeranda();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<HomeBloc>().authState$)
        .exhaustMap(validationAuth)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Result<AuthenticationState>?>(
      stream: widget.homeBloc.authState$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data?.orNull()?.userAndToken?.user;
          final beranda = snapshot.data?.orNull()?.userAndToken?.beranda;
          if (beranda != null) {
            final Map<String, dynamic> decodedToken = JwtDecoder.decode(beranda);
            dataHome = decodedToken['beranda'] ?? {};
          }
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  avatarProfile(context, user),
                  nextStepControl(dataHome),
                  const SizedBox(height: 16),
                  listTabs(context, widget.homeBloc),
                  dividerFull5(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TabContentBorrower(
                      icon: 'assets/images/icons/profile/logout.svg',
                      title: 'Logout',
                      isBottom: false,
                      onTap: () {
                        widget.homeBloc.logout();
                        _handleLogout();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return loadingScreen(context);
        }
      },
    );
  }

  Stream<void> validationAuth(response) async* {
    // await delay(1000);
  }

  Widget bodyHomeWidget(BuildContext context) {
    return Container();
  }

  Widget avatarProfile(BuildContext context, User? user) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: SvgPicture.asset(
                  'assets/images/home/background.svg',
                  fit: BoxFit.fitWidth,
                  height: 180,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 48,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/home/profile_user_icon.svg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Headline3(text: user?.username ?? ''),
                    const SizedBox(height: 7),
                    statusAccountControl(context, dataHome)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statusAccountControl(BuildContext context, Map<String, dynamic> data) {
    final int status = data['status']['aktivasi_status'];
    switch (status) {
      case 10:
        return statusAccountWidget(
          'assets/images/verification/verif.svg',
          'Akun terverifikasi',
          '#27AE60',
        );
      case 11:
        return statusAccountWidget(
          'assets/images/verification/not_verif.svg',
          'Akun tidak terverifikasi',
          '#EB5757',
        );
      case 12:
        return statusAccountWidget(
          'assets/images/verification/not_verif.svg',
          'Akun tidak terverifikasi',
          '#EB5757',
        );
      case 0:
        return statusAccountWidget(
          'assets/images/verification/unverif.svg',
          'Akun Belum terverifikasi',
          '#999999',
        );
      case 9:
        return statusAccountWidget(
          'assets/images/verification/unverif.svg',
          'Akun Belum terverifikasi',
          '#999999',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget statusAccountWidget(String image, String content, String color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F8F6),
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

  void _handleLogout() {
    initOnesignal();
    OneSignal.logout();
    OneSignal.User.removeAlias("fb_id");
  }

  Widget nextStepControl(Map<String, dynamic> data) {
    // final bool haveAll = data['status']['pekerjaan'] == true;
    final int status = data['status']['aktivasi_status'];
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }
    if (status == 10) {
      return const SizedBox.shrink();
    } else if (status == 0) {
      return verifikasiAkun(context);
    } else if (status == 10) {
      return aktivasiAkun(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget listTabs(BuildContext context, HomeBloc homeBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          checkIsVerifikasi(),
          checkBank(),
          TabContentBorrower(
            icon: 'assets/images/icons/profile/settings.svg',
            title: 'Pengaturan Akun',
            onTap: () {
              Navigator.pushNamed(context, SettingPageBorrower.routeName);
            },
          ),
          TabContentBorrower(
            icon: 'assets/images/icons/profile/syarat.svg',
            title: 'Syarat dan Ketentuan',
            onTap: () {
              Navigator.pushNamed(context, SyaratKetentuan.routeName);
            },
          ),
          TabContentBorrower(
            icon: 'assets/images/icons/profile/privasi.svg',
            title: 'Kebijakan Privasi',
            onTap: () {
              Navigator.pushNamed(context, KebijakanPrivasiPage.routeName);
            },
          ),
        ],
      ),
    );
  }

  Widget checkIsVerifikasi() {
    final int status = dataHome['status']['aktivasi_status'];
    if (status == 10) {
      return TabContentBorrower(
        icon: 'assets/images/icons/profile/person.svg',
        title: 'Informasi Pribadi',
        onTap: () {
          Navigator.pushNamed(
            context,
            InfoBorrowerPage.routeName,
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget checkBank() {
    final bool bankStatus = dataHome['status']['bank'];
    if (bankStatus == true) {
      return TabContentBorrower(
        icon: 'assets/images/icons/profile/credit_card.svg',
        title: 'Informasi Akun Bank',
        onTap: () {
          Navigator.pushNamed(context, InfoBankPage.routeName);
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget verifikasiAkun(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
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
            spreadRadius: 0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Subtitle2Extra(text: 'Lengkapi Data Diri'),
                const SizedBox(height: 4),
                Subtitle5(
                  text: 'Lengkapi data diri Anda untuk proses verifikasi data di Danain',
                  color: HexColor('#777777'),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, FillPersonalDataPage.routeName);
                  },
                  child: Subtitle4Extra(
                    text: 'Lengkapi Sekarang >',
                    color: HexColor(primaryColorHex),
                  ),
                )
              ],
            ),
          ),
          SvgPicture.asset('assets/images/verification/verif_logo.svg'),
        ],
      ),
    );
  }

  Widget aktivasiAkun(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
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
            spreadRadius: 0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Subtitle2Extra(text: 'Aktivasi Akun'),
                const SizedBox(height: 4),
                Subtitle5(
                  text: 'Lengkapi data pendukung untuk aktivasi akun dan menikmati layanan Danain',
                  color: HexColor('#777777'),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, CompleteDataPage.routeName);
                  },
                  child: Subtitle4Extra(
                    text: 'Lengkapi Sekarang >',
                    color: HexColor(primaryColorHex),
                  ),
                )
              ],
            ),
          ),
          SvgPicture.asset('assets/images/home/aktifasi_akun.svg'),
        ],
      ),
    );
  }

  Widget loadingScreen(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                LayoutBuilder(
                  builder: (context, BoxConstraints constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: SvgPicture.asset(
                        'assets/images/home/background.svg',
                        fit: BoxFit.fitWidth,
                        height: 180,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 48,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerCircle(height: 60, width: 60),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLong(
                            height: 18,
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                          const SizedBox(height: 16),
                          ShimmerLong(
                            height: 18,
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                tabContentLoading(context),
                tabContentLoading(context),
                tabContentLoading(context),
                tabContentLoading(context),
                tabContentLoading(context),
              ],
            ),
          ),
          dividerFull5(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: tabContentLoading(context),
          ),
        ],
      ),
    );
  }
}
