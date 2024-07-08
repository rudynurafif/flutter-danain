import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/home/home_state.dart';
import 'package:flutter_danain/pages/lender/home/page/beranda/beranda_lender.dart';
import 'package:flutter_danain/pages/lender/home/page/portfolio/portfolio_screen.dart';
import 'package:flutter_danain/pages/lender/home/page/profile/profile_page.dart';
import 'package:flutter_danain/pages/lender/login/login_page.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_pendanaan.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePageLender extends StatefulWidget {
  static const routeNeme = '/home_lender';
  final int index;
  const HomePageLender({
    super.key,
    this.index = 0,
  });

  @override
  State<HomePageLender> createState() => _HomePageLenderState();
}

class _HomePageLenderState extends State<HomePageLender>
    with
        SingleTickerProviderStateMixin<HomePageLender>,
        DidChangeDependenciesStream,
        DisposeBagMixin {
  int currentIndex = 0;
  Object? listen;
  @override
  void initState() {
    super.initState();
    final bloc = context.bloc<HomeLenderBloc>();
    bloc.errorMessage.listen(
      (value) {
        if (value != null) {
          value.toToastError(context);
        }
      },
    );
    setState(() {
      currentIndex = widget.index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<HomeLenderBloc>().messageBeranda$)
        .exhaustMap(validationBeranda)
        .collect()
        .disposedBy(bag);
    listen ??= BlocProvider.of<HomeLenderBloc>(context)
        .logoutMessage$
        .flatMap(handleMessage)
        .collect()
        .disposedBy(bag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<HomeLenderBloc>();
    final List<Widget> listWidget = [
      BerandaLenderScreen(homeBloc: bloc),
      PortfolioScreen(homeBloc: bloc),
      Container(color: Colors.red),
      const HelpTemporary(statusHome: true),
      ProfilePageLender(homeBloc: bloc),
    ];
    return Scaffold(
      body: listWidget.elementAt(currentIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor(lenderColor),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, NewPendanaanPage.routeName);
        },
        isExtended: true,
        child: SvgPicture.asset('assets/images/icons/payung.svg'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomBar(),
    );
  }

  Stream<void> validationBeranda(response) async* {
    await delay(1000);
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
                  currentIndex == 0 ? HexColor(lenderColor) : Colors.grey,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/home.svg'),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  currentIndex == 1 ? HexColor(lenderColor) : Colors.grey,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/portfolio.svg'),
              ),
              label: 'Portofolio',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 24),
              ),
              label: 'Danain',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  currentIndex == 3 ? HexColor(lenderColor) : Colors.grey,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/faq/icon_1.svg'),
              ),
              label: 'Bantuan',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  currentIndex == 4 ? HexColor(lenderColor) : Colors.grey,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('assets/images/icons/profile.svg'),
              ),
              label: 'Profil',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: HexColor(lenderColor),
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
            if (currentIndex == 2) {
              Navigator.pushNamed(context, NewPendanaanPage.routeName);
              setState(() {
                currentIndex = 0;
              });
            }
          },
        ),
      ),
    );
  }

  Stream<void> handleMessage(HomeLenderMessage message) async* {
    debugPrint('[DEBUG] homeBloc message=$message');

    if (message is LogoutLenderMessage) {
      if (message is LogoutLenderSuccessMessage) {
        await Navigator.of(context).pushNamedAndRemoveUntil(
          LoginLenderPage.routeName,
          (_) => false,
        );
        const messageLogout = 'Berhasil logout';
        messageLogout.toToastError(context);
        return;
      }
      if (message is LogoutLenderErrorMessage) {
        context.showSnackBar('Error when logout: ${message.message}');
        return;
      }
      return;
    }
  }
}
