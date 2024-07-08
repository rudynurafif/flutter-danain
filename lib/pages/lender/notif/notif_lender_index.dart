import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/notif/notif_lender_bloc.dart';
import 'package:flutter_danain/pages/lender/notif/notif_lender_page.dart';
import 'package:flutter_danain/pages/lender/notif/notif_pesan_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class NotifikasiLenderPage extends StatefulWidget {
  static const routeName = '/notifikasi_lender';
  const NotifikasiLenderPage({super.key});

  @override
  State<NotifikasiLenderPage> createState() => _NotifikasiLenderPageState();
}

class _NotifikasiLenderPageState extends State<NotifikasiLenderPage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 2,
    );

    final bloc = BlocProvider.of<NotifLenderBloc>(context);
    bloc.setPageNotif(1);
    bloc.getNotif(1);
    bloc.setPagePesan(1);
    bloc.getPesan(1);
    print('indexnya bang: ${tabController.index}');
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotifLenderBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushNamed(context, HomePageLender.routeNeme);
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Headline2500(text: 'Notifikasi'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, HomePageLender.routeNeme,),
              icon: SvgPicture.asset('assets/images/icons/back.svg'),
            ),
            elevation: 0,
            toolbarHeight: 50,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(26, 158, 158, 158),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TabBar(
                      // controller: tabController,
                      unselectedLabelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: HexColor(lenderColor),
                      dividerColor: Colors.white,
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 4,
                            color: HexColor(lenderColor),
                          ),
                        ),
                      ),
                      controller: tabController,
                      onTap: (value) {
                        setState(() {
                          index = value;
                        });
                        tabController.index = value;
                      },
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Headline3500(
                                text: 'Notifikasi',
                                color: tabController.index == 0
                                    ? HexColor(lenderColor)
                                    : HexColor('#AAAAAA'),
                              ),
                              StreamBuilder(
                                  stream: bloc.notifList,
                                  builder: (context, snapshot) {
                                    final data = snapshot.data ?? [];
                                    final notRead =
                                        data.where((e) => e['tis_read'] == 0);
                                    if (notRead.length > 0) {
                                      return const Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 8,
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  })
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Headline3500(
                                text: 'Pesan ',
                                color: tabController.index == 1
                                    ? HexColor(lenderColor)
                                    : HexColor('#AAAAAA'),
                              ),
                              StreamBuilder(
                                stream: bloc.pesanList,
                                builder: (context, snapshot) {
                                  final data = snapshot.data ?? [];
                                  final notRead =
                                      data.where((e) => e['tis_read'] == 0);
                                  if (notRead.length > 0) {
                                    return const Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                      size: 8,
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              NotifikasiLenderScreen(nBloc: bloc),
              PesanLenderPage(nBloc: bloc),
            ],
          ),
        ),
      ),
    );
  }
}

Widget contentNotifLender(
  BuildContext context,
  String icon,
  String title,
  String subtitle,
  String tanggal,
  int isRead,
) {
  return Container(
    color: isRead == 1 ? Colors.white : HexColor('#E9F6EB'),
    padding: const EdgeInsets.all(16),
    width: MediaQuery.of(context).size.width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          icon,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline3500(text: title),
              const SizedBox(height: 4),
              Subtitle2(
                text: subtitle,
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Subtitle3(
                text: formatDateNormal(tanggal),
                color: HexColor('#AAAAAA'),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
