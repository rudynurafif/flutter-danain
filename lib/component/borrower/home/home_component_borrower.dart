import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/home_page.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/profile_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/transaksi_page.dart';
// import 'package:flutter_danain/pages/borrower/menu/transaction/transaction_page.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../data/remote/onesignal.dart';
// import '../../borrower/home/home_bloc.dart';

class HomeComponentBorrower extends StatefulWidget {
  final int index;
  final int subIndex;
  const HomeComponentBorrower({
    super.key,
    required this.index,
    required this.subIndex,
  });
  @override
  State<HomeComponentBorrower> createState() => _HomeComponentBorrowerState();
}

class _HomeComponentBorrowerState extends State<HomeComponentBorrower>
    with
        SingleTickerProviderStateMixin<HomeComponentBorrower>,
        DisposeBagMixin {
  int _currentIndex = 0;
  late final AnimationController rotateLogoController;
  Object? listen;
  String? _emailAddress;
  String? _smsNumber;
  int? _externalUserId;
  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = widget.index;
    });
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    Timer.periodic(const Duration(seconds: 700), (timer) {
      homeBloc.setBeranda();
    });
    rotateLogoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    initPlatformState(homeBloc);
  }

  Future<void> initPlatformState(HomeBloc homeBloc) async {
    await for (final result in homeBloc.authState$) {
      print('result auth $result');
      return result?.fold(
          ifLeft: (appError) {},
          ifRight: (authState) async {
            if (!mounted) return;
            _emailAddress = authState.userAndToken?.user.email;
            _smsNumber = authState.userAndToken?.user.tlpmobile;
            _externalUserId = authState.userAndToken?.user.idborrower;
            print('check user id $_externalUserId');
            await initOnesignal();
            _handleLogin(_externalUserId);
            _handleSetEmail();
            _handleSetSMSNumber();
          });
    }
  }

  void _handleSetSMSNumber() async {
    if (_smsNumber == null) return;

    print("Setting SMS Number: $_smsNumber");

    try {
      await OneSignal.User.addSms(_smsNumber!);
      print("SMS Number set successfully.");
    } catch (e) {
      print("Error setting SMS Number: $e");
      // Handle the error as needed
    }
  }

  void _handleSetEmail() {
    if (_emailAddress == null) {
      print("Email address is null");
      return;
    }

    print("Setting email");
    try {
      OneSignal.User.addEmail(_emailAddress!);
    } catch (e) {
      print("Error setting email: $e");
    }
  }

  void _handleLogin(int? externalUserId) {
    if (externalUserId == null) {
      print("External user ID is null");
      return;
    }

    print("Setting external user ID $externalUserId");

    try {
      OneSignal.login(externalUserId.toString());
      OneSignal.User.addAlias("fb_id", "1341524");
    } catch (e) {
      print("Error in OneSignal operations: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    rotateLogoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    final List<Widget> listContent = [
      HomePageAfterLogin(homeBloc: homeBloc),
      // TransactionPage(
      //   homeBloc: homeBloc,
      //   index: widget.subIndex,
      // ),
      TransactionPage(
        homeBloc: homeBloc,
        index: widget.subIndex,
      ),
      const HelpTemporary(statusHome: true),
      ProfilePageBorrower(homeBloc: homeBloc),
    ];

    return Scaffold(
      body: listContent.elementAt(_currentIndex),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget bottomBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, -3),
              spreadRadius: 0,
            )
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color(0xFFAAAAAA),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 0
                      ? const Color(0xff24663F)
                      : const Color(0xFFAAAAAA),
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/home.svg'),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 1
                      ? const Color(0xff24663F)
                      : const Color(0xFFAAAAAA),
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/history.svg'),
              ),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 2
                      ? const Color(0xff24663F)
                      : const Color(0xFFAAAAAA),
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/help.svg'),
              ),
              label: 'Bantuan',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 3
                      ? const Color(0xff24663F)
                      : const Color(0xFFAAAAAA),
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/profile.svg'),
              ),
              label: 'Profil',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: HexColor(borrowerColor),
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
