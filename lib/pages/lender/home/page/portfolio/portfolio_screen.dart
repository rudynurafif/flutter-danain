import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/home/page/portfolio/pendanaan_aktif.dart';
import 'package:flutter_danain/pages/lender/home/page/portfolio/pendanaan_selesai.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_pendanaan.dart';
import 'package:flutter_danain/pages/lender/portfolio/riwayatTransaksi/riwayat_transaksi_page.dart';
import 'package:flutter_danain/utils/type_defs.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PortfolioScreen extends StatefulWidget {
  final HomeLenderBloc homeBloc;
  const PortfolioScreen({super.key, required this.homeBloc});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController scrollController = ScrollController();
  final menuSelected = BehaviorSubject<int>.seeded(1);
  final page = BehaviorSubject<int>.seeded(1);
  bool isHide = false;
  final String isHideText = '• • • • • • •';

  @override
  void initState() {
    super.initState();
    widget.homeBloc.getDataPortofolio();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.homeBloc;
    return RefreshIndicator(
      onRefresh: () async {
        return widget.homeBloc.getDataPortofolio();
      },
      child: Parent(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(
            context: context,
            isLeading: false,
            title: 'Portofolio',
            elevation: 0,
          ),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              LayoutBuilder(
                builder: (context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: SvgPicture.asset(
                      'assets/lender/portofolio/background.svg',
                      fit: BoxFit.fitWidth,
                    ),
                  );
                },
              ),
              bodyBuilder(bloc)
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyBuilder(HomeLenderBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          portofolioWidget(bloc),
          const SpacerV(value: 26),
          riwayatTransaksi(),
          const SpacerV(value: 32),
          selectMenu(bloc),
          const SpacerV(value: 32),
          listPendanaanScreen(bloc),
        ],
      ),
    );
  }

  Widget portofolioWidget(HomeLenderBloc bloc) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: bloc.summaryData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle3(
                text: 'Total Nilai Akun',
                color: HexColor('#AAAAAA'),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Headline2(
                    text: isHide
                        ? isHideText
                        : rupiahFormat(
                            data['totalNilaiAkun'],
                          ),
                    color: isHide ? HexColor(lenderColor) : null,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                    child: Icon(
                      isHide
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              dividerFullNoPadding(context),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle3(
                          text: 'Saldo Tersedia',
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(height: 4),
                        Headline3500(
                          text: isHide
                              ? isHideText
                              : rupiahFormat(
                                  data['saldoTersedia'],
                                ),
                          color: isHide ? HexColor(lenderColor) : null,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle3(
                        text: 'Pendanaan Aktif',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      Headline3500(
                        text: isHide
                            ? isHideText
                            : rupiahFormat(
                                (data['pendanaanAktif'] ?? {})['nominal'] ?? 0,
                              ),
                        color: isHide ? HexColor(lenderColor) : null,
                      ),
                    ],
                  )
                ],
              ),
              const SpacerV(),
              const DividerWidget(height: 1),
              const SpacerV(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle3(
                          text: 'Imbal Hasil',
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(height: 4),
                        Headline3500(
                          text: isHide
                              ? isHideText
                              : rupiahFormat(
                                  data['imbalHasil'],
                                ),
                          color: isHide ? HexColor(lenderColor) : null,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Subtitle3(
                            text: 'Rerata Tertimbang ',
                            color: HexColor('#AAAAAA'),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => ModalDetailAngsuran(
                                  content: rerataTertimbang(),
                                ),
                              );
                            },
                            child: Transform.rotate(
                              angle: 3.14159265,
                              child: Icon(Icons.error_outline_outlined,
                                  color: HexColor('#AAAAAA'), size: 14),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Headline3500(
                        text:
                            '${data['rerataTertimbang']?['rate']?['nominal'] ?? 0}% p.a',
                        color: HexColor(lenderColor),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        }
        return portofolioLoading(context);
      },
    );
  }

  Widget rerataTertimbang() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Subtitle2Extra(text: 'Rerata Tertimbang'),
        const SizedBox(height: 8),
        Subtitle3(
          text:
              'Rerata Tertimbang merupakan tingkat pendapatan bunga yang Anda lakukan di Danain.',
          color: HexColor('#777777'),
        )
      ],
    );
  }

  Widget riwayatTransaksi() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RiwayatTransaksiPage.routeName);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/lender/portofolio/calculator.svg',
                ),
                const SizedBox(width: 8),
                const Subtitle2(text: 'Riwayat Transaksi')
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right_outlined,
              color: HexColor(lenderColor),
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget portofolioLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerLong(height: 11, width: 100),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerLong(
              height: 14,
              width: MediaQuery.of(context).size.width / 2,
            ),
            const ShimmerCircle(height: 20, width: 20),
          ],
        ),
        const SizedBox(height: 12),
        dividerFullNoPadding(context),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerLong(height: 11, width: 100),
                  const SizedBox(height: 8),
                  ShimmerLong(
                    height: 14,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  const SizedBox(height: 16),
                  const ShimmerLong(height: 11, width: 100),
                  const SizedBox(height: 8),
                  ShimmerLong(
                    height: 14,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerLong(height: 11, width: 100),
                  const SizedBox(height: 8),
                  ShimmerLong(
                    height: 14,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  const SizedBox(height: 16),
                  const ShimmerLong(height: 11, width: 100),
                  const SizedBox(height: 8),
                  ShimmerLong(
                    height: 14,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget selectMenu(HomeLenderBloc bloc) {
    return StreamBuilder<int>(
      stream: menuSelected.stream,
      builder: (context, snapshot) {
        final menu = snapshot.data ?? 1;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            menuContent(
              title: 'Pendanaan Aktif',
              menu: 1,
              isSelected: menu == 1,
              onSelect: (value) {
                menuSelected.add(value);
              },
            ),
            menuContent(
              title: 'Pendanaan Selesai',
              menu: 2,
              isSelected: menu == 2,
              isFirst: false,
              onSelect: (value) {
                menuSelected.add(value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget listPendanaanScreen(HomeLenderBloc bloc) {
    return StreamBuilder<int>(
      stream: menuSelected.stream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 0;
        if (data == 1) {
          return PendanaanAktif(
            homeBloc: bloc,
            controller: scrollController,
          );
        }
        if (data == 2) {
          return PendanaanSelesai(
            homeBloc: bloc,
            controller: scrollController,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget menuContent({
    required String title,
    required int menu,
    required bool isSelected,
    required Function1<int, void> onSelect,
    bool isFirst = true,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelect(menu),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? HexColor(lenderColor) : HexColor('#EFEFEF'),
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
        ),
        child: Subtitle2(
          text: title,
          color: isSelected ? Colors.white : HexColor('#999999'),
        ),
      ),
    );
  }
}

Widget emptyListWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/icons/no_message.svg'),
        const SizedBox(height: 8),
        const Headline2(
          text: 'Belum Ada Pendanaan',
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Subtitle2(
          text:
              'Lakukan pendanaan sekarang dan lihat perkembangan pendanaan di sini',
          align: TextAlign.center,
          color: HexColor('#777777'),
        ),
        const SizedBox(height: 40),
        Button1(
          btntext: 'Buat Pendanaan Baru',
          color: HexColor(lenderColor),
          action: () {
            Navigator.pushNamed(context, NewPendanaanPage.routeName);
          },
        )
      ],
    ),
  );
}

Widget emptyFilter(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/icons/no_message.svg'),
        const SizedBox(height: 8),
        const Headline2(
          text: 'Data Tidak Ditemukan',
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Subtitle2(
          text:
              'Kami tidak menemukan pendanaan yang sesuai filter ini. Coba pilih filter yang lain atau reset filter.',
          align: TextAlign.center,
          color: HexColor('#777777'),
        ),
      ],
    ),
  );
}
