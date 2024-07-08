import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/component/home/action_modal_component.dart';
import 'package:flutter_danain/component/home/verif_component.dart';
import 'package:flutter_danain/component/lender/modal_component/modal_pendanaan.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman.page.dart';
import 'package:flutter_danain/pages/lender/home/component/beranda_component.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/home/page/beranda/beranda_loading.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/components/new_pendanaan.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_pendanaan.dart';
import 'package:flutter_danain/pages/lender/notif/notif_lender_index.dart';
import 'package:flutter_danain/pages/lender/setor_dana/setor_dana_page.dart';
import 'package:flutter_danain/pages/lender/tarik_dana/tarik_dana_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaLenderSuccess extends StatefulWidget {
  final HomeLenderBloc homeBloc;
  final Map<String, dynamic> dataHome;
  const BerandaLenderSuccess({
    super.key,
    required this.homeBloc,
    required this.dataHome,
  });

  @override
  State<BerandaLenderSuccess> createState() => _BerandaLenderSuccessState();
}

class _BerandaLenderSuccessState extends State<BerandaLenderSuccess> {
  bool isHide = false;
  String isHideText = '• • • • • • •';
  int currentIndex = 0;
  int indexInfo = 0;
  @override
  Widget build(BuildContext context) {
    final data = widget.dataHome;
    final status = data['status'] ?? {};
    return RefreshIndicator(
      onRefresh: () async {
        widget.homeBloc.getDataHome();
      },
      child: Scaffold(
        backgroundColor: HexColor('#F5F9F6'),
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/lender/home/bg_top.svg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            Column(
              children: [
                const SpacerV(value: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo/danain2.svg',
                        width: 74,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const TkbLender(),
                          const SpacerH(value: 16),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                NotifikasiLenderPage.routeName,
                              );
                            },
                            child: data['status']['notif'] > 0
                                ? SvgPicture.asset(
                                    'assets/images/icons/notif.svg')
                                : const Icon(
                                    Icons.notifications,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            Column(
                              children: [
                                const SpacerV(value: 150),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: HexColor('#F5F9F6'),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                nameWidget(data['namaLender'] ?? ''),
                                const SizedBox(height: 8),
                                StreamBuilder<Map<String, dynamic>?>(
                                  stream: widget.homeBloc.summaryData,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final summary = snapshot.data ?? {};
                                      return saldoWidget(
                                        imbalHasil: summary['imbalHasil'] ?? 0,
                                        rerata: (summary['rerataTertimbang']
                                                ?['rate']?['nominal'] ??
                                            0),
                                        saldoTersedia:
                                            summary['saldoTersedia'] ?? 0,
                                      );
                                    }
                                    return saldoLoading(context);
                                  },
                                ),
                                Container(
                                  color: HexColor('#F5F9F6'),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      menuWidget(
                                        rdlStatus: status['rdl'] ?? 0,
                                        statusAktivasi: status['Aktivasi'] ?? 0,
                                        statusBank: status['bank'] ?? 0,
                                        username: data['namaLender'] ?? 'Jhon',
                                      ),
                                      accountVerifWidget(
                                        status: status,
                                      ),
                                      peluangPendanaan(widget.homeBloc),
                                      infoPromoWidget(Constants.get.infoPromo),
                                      const SpacerV(value: 16),
                                      artikelWidget(
                                          artikel: data['artikel'] ?? []),
                                      const SpacerV(value: 16),
                                      footerHome(context),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget nameWidget(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubtitleExtra(
            text: 'Hai, ',
            color: Colors.white,
          ),
          Headline3(
            text: name,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget saldoWidget({
    num saldoTersedia = 0,
    num rerata = 0,
    num imbalHasil = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Saldo Tersedia',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Subtitle2Extra(
                      text: isHide ? '' : 'Rp ',
                      color: HexColor('#5F5F5F'),
                    ),
                    Headline2500(
                      text: isHide
                          ? isHideText
                          : rupiahFormat2(
                              saldoTersedia,
                            ),
                      color: isHide ? HexColor(lenderColor) : null,
                    ),
                  ],
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
            const SizedBox(height: 12),
            dividerFullNoPadding(context),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Subtitle4(
                      text: 'Imbal Hasil',
                      color: HexColor('#AAAAAA'),
                    ),
                    const SizedBox(height: 4),
                    Subtitle2Extra(
                      text: isHide
                          ? isHideText
                          : rupiahFormat(
                              imbalHasil,
                            ),
                      color: HexColor(lenderColor),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 22.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Subtitle4(
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
                              child: Icon(
                                Icons.error_outline_outlined,
                                color: HexColor('#AAAAAA'),
                                size: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Subtitle2Extra(
                        text: '$rerata% p.a',
                        color: HexColor(lenderColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget peluangPendanaan(HomeLenderBloc bloc) {
    return StreamBuilder<List<dynamic>?>(
      stream: bloc.listPemula,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? [];
          if (data.isNotEmpty) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextWidget(
                          text: 'Peluang Pendanaan',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NewPendanaanPage.routeName,
                            );
                          },
                          child: const TextWidget(
                            text: 'Lihat semua',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff27AE60),
                          ),
                        ),
                      ],
                    ),
                  ),
                  carouselPendanaan(data),
                ],
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget accountVerifWidget({
    required Map<String, dynamic> status,
  }) {
    switch (status['Aktivasi']) {
      case 10:
        return haveverifData(context);
      case 9:
        return waitingVerifDataLender(context);
      case 0:
        return haventverifDataLender(context);
      // case 12:
      //   return privyRejectedLender(context);
      // case 11:
      //   switch (statusPrivy['code']) {
      //     case null:
      //       return privyRejected(context);
      //     default:
      //       return privyFixDocumentLender(
      //         context,
      //         statusPrivy,
      //         statusPrivy['code']['dataUpdate'] ?? [],
      //       );
      //   }
      case 1:
        switch (status['rdl']) {
          case 0:
            return rdlWidget(context);
          default:
            return const SizedBox.shrink();
        }
      default:
        return const SizedBox.shrink();
    }
  }

  Widget carouselPendanaan(List<dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: data.length,
          itemBuilder: (context, index, realIndex) {
            final e = data[realIndex];
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: NewPendanaanWidget(
                    idPendanaan: e['idAgreement'],
                    namaProduk: e['namaProduk'],
                    picture: e['img'],
                    noPerjanjianPinjaman: e['noPengajuan'],
                    jumlahPendanaan: e['pokokHutang'],
                    tenor: e['tenor'],
                    bunga: e['ratePendana'],
                    paddingB: 0,
                    idAgreement: e['idAgreement'],
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            reverse: false,
            height: 170,
            disableCenter: false,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            enlargeFactor: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < data.length; i++)
              Container(
                height: 8,
                width: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: currentIndex == i
                      ? HexColor(lenderColor)
                      : HexColor('#E5E5E5'),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
        const SpacerV(value: 16),
      ],
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

  Widget menuWidget({
    String username = '',
    int statusAktivasi = 0,
    int rdlStatus = 0,
    int statusBank = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  SetorDanaLenderPage.routeName,
                );
                // if (statusAktivasi == 0) {
                //   showDialog(
                //     context: context,
                //     builder: (context) => notVerifPopUp(context),
                //   );
                // }
                // if (statusAktivasi == 9) {
                //   showDialog(
                //     context: context,
                //     builder: (context) => waitingVerifPopUp(context),
                //   );
                // }
                // if (statusAktivasi == 11 || statusAktivasi == 12) {
                //   showDialog(
                //     context: context,
                //     builder: (context) => rejectVerifPopUp(context),
                //   );
                // }

                // if (statusAktivasi == 1) {
                //   if (rdlStatus == 1) {
                //     Navigator.of(context).pushNamed(
                //       SetorDanaLenderPage.routeName,
                //     );
                //   } else {
                //     showDialog(
                //       context: context,
                //       builder: (context) => regisRdlPopUp(context),
                //     );
                //   }
                // }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/lender/home/setordana.svg'),
                  const SizedBox(height: 4),
                  const Subtitle3(text: 'Setor Dana'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (statusBank != 0) {
                  //   if (statusAktivasi == 0) {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => notVerifPopUp(context),
                  //     );
                  //   }
                  //   if (statusAktivasi == 9) {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => waitingVerifPopUp(context),
                  //     );
                  //   }
                  //   if (statusAktivasi == 11 || statusAktivasi == 12) {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => rejectVerifPopUp(context),
                  //     );
                  //   }

                  // if (statusAktivasi == 1) {
                  Navigator.pushNamed(context, TarikDanaPage.routeName);
                  // }
                } else {
                  showHasnotBankAlert(context, username);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/lender/home/tarikdana.svg'),
                  const SizedBox(height: 4),
                  const Subtitle3(text: 'Tarik Dana'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, SimulasiPendanaanPage.routeName);
                showDialog(
                  context: context,
                  builder: (context) {
                    return ModalPopUpNoClose2(
                      icon: 'assets/lender/home/development.svg',
                      title: 'Nantikan yang Baru di Danain',
                      message:
                          'Danain sedang mempersiapkan sesuatu yang baru. Nantikan dan nikmati layanan terbaik kami',
                      actions: [
                        Button2(
                          btntext: 'OK',
                          action: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/lender/home/simulasi.svg'),
                  const SizedBox(height: 4),
                  const Subtitle3(text: 'Simulasi'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ModalPopUpNoClose2(
                      icon: 'assets/lender/home/development.svg',
                      title: 'Nantikan yang Baru di Danain',
                      message:
                          'Danain sedang mempersiapkan sesuatu yang baru. Nantikan dan nikmati layanan terbaik kami',
                      actions: [
                        Button2(
                          btntext: 'OK',
                          action: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/lender/home/hadiah.svg'),
                  const SizedBox(height: 4),
                  const Subtitle3(text: 'Hadiah'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoPromoWidget(List<dynamic> data) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: TextWidget(
              text: 'Info dan Promo Danain',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                itemCount: data.length,
                itemBuilder: (context, index, realIndex) {
                  final e = data[realIndex];
                  return Column(
                    children: [
                      Container(
                        margin: realIndex == 0
                            ? const EdgeInsets.only(right: 10)
                            : const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () async {
                            if (e['isNavigateExternal'] == 1) {
                              if (await canLaunch(e['navigate'])) {
                                await launch(e['navigate']);
                              } else {
                                throw 'Could not launch ${e['navigate']}';
                              }
                            } else {
                              await Navigator.pushNamed(
                                context,
                                AjakTemanPage.routeName,
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              e['image'],
                              width: MediaQuery.of(context).size.width - 50,
                              height: 150,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  height: 166,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  reverse: false,
                  disableCenter: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.9,
                  enlargeFactor: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      indexInfo = index;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < data.length; i++)
                    Container(
                      height: 8,
                      width: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: indexInfo == i
                            ? HexColor(lenderColor)
                            : HexColor('#E5E5E5'),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              const SpacerV(value: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget artikelWidget({
    required List<dynamic> artikel,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Artikel Danain',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              InkWell(
                onTap: () {},
                child: TextWidget(
                  text: 'Lihat Semua',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: HexColor(lenderColor),
                ),
              ),
            ],
          ),
          const SpacerV(),
          TextWidget(
            text:
                'Seputar berita dan informasi mengenai Danain dan pengelolaan finansial',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: HexColor('#777777'),
          ),
          const SpacerV(value: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: artikel.asMap().entries.map((entry) {
              final e = entry.value;
              final index = entry.key;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (await canLaunch(e['link'])) {
                    await launch(e['link']);
                  } else {
                    throw 'Could not launch ${e['link']}';
                  }
                },
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              e['img'] ?? '',
                              width: 105,
                              height: 74,
                              fit: BoxFit.fitHeight,
                              errorBuilder: (context, error, stackTrace) {
                                return const ShimmerLong(
                                  width: 104,
                                  height: 74,
                                );
                              },
                            ),
                          ),
                          const SpacerH(value: 18),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: e['headline'].toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SpacerV(),
                                TextWidget(
                                  text: dateFormatComplete(
                                    e['dateTime'].toString(),
                                  ),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: HexColor('#AAAAAA'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (index != (artikel.length - 1))
                      const Column(
                        children: [
                          DividerWidget(height: 1),
                          SpacerV(value: 12),
                        ],
                      ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget footerHome(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  TextWidget(
                    text: 'PT. Mulia Inovasi Digital',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  SpacerV(value: 2),
                  TextWidget(
                    text: 'berizin dan diawasi oleh',
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffAAAAAA),
                  ),
                ],
              ),
              const SpacerH(),
              const DividerWidget(height: 30, width: 1),
              const SpacerH(),
              SvgPicture.asset('assets/images/logo/logo_ojk.svg')
            ],
          ),
          const SpacerV(value: 25)
        ],
      ),
    );
  }
}
