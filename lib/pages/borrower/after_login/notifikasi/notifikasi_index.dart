import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/notifikasi_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/notifikasi_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/pesan_page.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class NotifikasiPage extends StatefulWidget {
  static const routeName = '/notifikasi_screen';
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<NotifBloc>(context);
    tabController = TabController(
      vsync: this,
      length: 2,
    );
    tabController.addListener(() {
      print('sip bang ${tabController.index}');
      setState(() {
        index = tabController.index;
      });
      print('indexnya bang: $index');
    });
    bloc.setPageNotif(1);
    bloc.getNotif(1);
    bloc.setPagePesan(1);
    bloc.getPesan(1);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotifBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushNamed(context, HomePage.routeName);
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
              onPressed: () => Navigator.pushNamed(context, HomePage.routeName),
              icon: SvgPicture.asset('assets/images/icons/back.svg'),
            ),
            elevation: 0,
            toolbarHeight: 50,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Column(
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
                    decoration: const BoxDecoration(color: Colors.white),
                    child: TabBar(
                      controller: tabController,
                      unselectedLabelColor: Colors.white,
                      dividerColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: HexColor(primaryColorHex),
                      onTap: (value) {
                        setState(() {
                          index = value;
                        });
                      },
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 4,
                            color: HexColor(primaryColorHex),
                          ),
                        ),
                      ),
                      tabs: [
                        Tab(
                          // text: 'Notifikasi',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Headline3500(
                                text: 'Notifikasi ',
                                color: tabController.index == 0
                                    ? HexColor(primaryColorHex)
                                    : HexColor('#AAAAAA'),
                              ),
                              StreamBuilder(
                                  stream: bloc.notifList,
                                  builder: (context, snapshot) {
                                    final data = snapshot.data ?? [];
                                    final notRead =
                                        data.where((e) => e['is_read'] == 0);
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
                                    ? HexColor(primaryColorHex)
                                    : HexColor('#AAAAAA'),
                              ),
                              StreamBuilder(
                                stream: bloc.pesanList,
                                builder: (context, snapshot) {
                                  final data = snapshot.data ?? [];
                                  final notRead =
                                      data.where((e) => e['is_read'] == 0);
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
              NotifikasiScreen(nBloc: bloc),
              PesanPage(nBloc: bloc),
            ],
          ),
        ),
      ),
    );
  }
}

Widget contentNotifikasi(
  BuildContext context,
  String title,
  String subtitle,
  String tanggal,
  int isRead,
) {
  return Container(
    color: isRead == 1 ? Colors.white : HexColor('#E9F6EB'),
    padding: const EdgeInsets.all(16),
    width: MediaQuery.of(context).size.width,
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
        const SizedBox(height: 4),
        Subtitle3(
          text: formatDateNormal(tanggal),
          color: HexColor('#AAAAAA'),
        )
      ],
    ),
  );
}

Widget notifikasiLoading(BuildContext context) {
  final List<dynamic> data = [{}, {}, {}];
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.map((e) {
      return Container(
        color: HexColor('#E9F6EB'),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLong(
                height: 14, width: MediaQuery.of(context).size.width / 2),
            const SizedBox(height: 8),
            ShimmerLong(height: 12, width: MediaQuery.of(context).size.width),
            const SizedBox(height: 8),
            ShimmerLong(
                height: 11, width: MediaQuery.of(context).size.width / 4),
          ],
        ),
      );
    }).toList(),
  );
}
