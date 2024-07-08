import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_va_pinjaman_state.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_pinjaman_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../auxpage/dokumen_perjanjian_pinjaman.dart';
import '../../../../home/home_page.dart';
import 'detail_riwayat_loading.dart';
import 'detail_riwayat_pinjaman_bloc.dart';

class DetailRiwayatPinjaman extends StatefulWidget {
  static const routeName = '/detail_riwayat_pinjaman';
  const DetailRiwayatPinjaman({super.key});

  @override
  State<DetailRiwayatPinjaman> createState() => _DetailRiwayatPinjamanState();
}

class _DetailRiwayatPinjamanState extends State<DetailRiwayatPinjaman>
    with DisposeBagMixin, DidChangeDependenciesStream {
  List<String> barangAgunan = [
    'Cincin',
    'Gelang',
  ];
  List<String> beratAgunan = [
    '10 gr',
    '3 gr',
  ];
  List<String> karatAgunan = [
    '24k',
    '25k',
  ];

  bool _expanded = false;
  bool _expandedPelunasan = false;
  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<DetailRiwayatPinjamanBloc>().messageVa)
        .exhaustMap((value) => handleMessageVa(value))
        .listen((_) {});
    // Delay the code execution to ensure initState has completed
    Future.delayed(const Duration(seconds: 3), () {
      final detailPengajuanBloc =
          BlocProvider.of<DetailRiwayatPinjamanBloc>(context);
      final dynamic argument = ModalRoute.of(context)!.settings.arguments;
      detailPengajuanBloc.idAggrementChange(argument);
      detailPengajuanBloc.detailPinjamanChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailPengajuanBloc =
        BlocProvider.of<DetailRiwayatPinjamanBloc>(context);
    final dynamic argument = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: StreamBuilder(
          stream: detailPengajuanBloc.messageDetailPinjamanStream$,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              print('data pinjamannya bang ${data}');
              return AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset('assets/images/icons/back.svg'),
                ),
                title: Column(
                  children: [
                    const SizedBox(height: 24),
                    Headline2500(
                      text: 'Detail Pinjaman',
                      align: TextAlign.center,
                      color: HexColor('#333333'),
                    ),
                    Subtitle3(
                      text:
                          'No. PP. ${data['data_detail']['no_perjanjian_pinjaman']}',
                      color: const Color(0xFFAAAAAA),
                    ),
                  ],
                ),
                centerTitle: true,
              );
            } else if (snapshot.hasError) {
              return AppBar(
                title: Text('Error: ${snapshot.error}'),
              );
            } else {
              return AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset('assets/images/icons/back.svg'),
                ),
                title: Column(
                  children: [
                    const SizedBox(height: 24),
                    Headline2500(
                      text: 'Detail Pinjaman',
                      align: TextAlign.center,
                      color: HexColor('#333333'),
                    ),
                    const Subtitle3(
                      text: 'No. PP.',
                      color: Color(0xFFAAAAAA),
                    )
                  ],
                ),
                centerTitle: true,
              );
            }
          },
        ),
      ),
      body: StreamBuilder(
        stream: detailPengajuanBloc.messageDetailPinjamanStream$,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DetailPinjamanLoading();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Replace this part with how you want to display data from the stream.
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageDetail(context, data),
                  totalPinjaman(data),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: detailPinjaman(data),
                  ),
                  dividerFull(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: agunanWidget(data),
                  ),
                  dividerFull(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: totalPelunasanWidget(data),
                  ),
                  dividerFull(context),
                  data['dokumen_perjanjian'] == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: dokumenPerjanjian(data),
                        ),
                  dividerFull(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: waktuPengajuan(data),
                  ),
                  dividerFull(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: penjualanAgunan(
                      detailPengajuanBloc,
                      data,
                      argument,
                      context,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Stream<void> handleMessageVa(message) async* {
    if (message is DetailVaSuccess) {
      await Navigator.pushNamed(
        context,
        PembayaranPinjamanPage.routeName,
        arguments: PembayaranPinjamanPage(
          dataPinjaman: message.data,
        ),
      );
    }

    if (message is DetailVaError) {
      print('errornya bang ${message.error}');
      context.showSnackBarError(message.message);
    }
  }

  Widget penjualanAgunan(
    DetailRiwayatPinjamanBloc bloc,
    data,
    argument,
    BuildContext context,
  ) {
    final statusAgunan = data['data_detail']['status'];

    Widget widgetCondition = Container(); // Provide a default value

    switch (statusAgunan) {
      case 'Aktif':
        widgetCondition = buttonPembayaran(bloc);
        break;
      case 'Proses Pencairan':
        widgetCondition =
            penjualanAguranProsesPencairan(data, argument, context);
        break;
      case 'Telat Bayar':
        widgetCondition = buttonPembayaran(bloc);
        break;
      case 'Selesai':
        widgetCondition = PenjualanAgunanDone(data, context);
        break;
      case 'Terlambat':
        widgetCondition = PenjualanAgunanDone(data, context);
        break;
      case 'Lunas':
        widgetCondition = PenjualanAgunanDone(data, context);
        break;

      case 'Gagal Bayar':
        widgetCondition = penjualanAgunanGagal(data, context);
        break;
      case 'Pemutusan':
        widgetCondition = PenjualanAgunanPemutusan(data, context);
        break;
      case 'Proses Jual':
        widgetCondition = PenjualanAgunanPemutusan(data, context);
        break;
      // Add more cases for other status values if needed
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widgetCondition,
      ],
    );
  }

  Widget buttonPembayaran(DetailRiwayatPinjamanBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.isLoading,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;
        if (isLoading == true) {
          return const ButtonLoading();
        }
        return Button1(
          btntext: 'Bayar Pinjaman',
          color: HexColor(primaryColorHex),
          action: () {
            bloc.getVa();
          },
        );
      },
    );
  }

  Widget PenjualanAgunanPemutusan(data, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: HexColor('#FDEEEE'),
        border: Border.all(
          width: 1,
          color: HexColor('#FBDDDD'),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
              'assets/lender/portofolio/pembatalan_cicil_emas.svg'),
          const SizedBox(width: 8),
          Flexible(
            child: Subtitle2(
              text:
                  'Dikarenakan terjadi kegagalan pembayaran, saat ini agunan sedang dalam tahap proses penjualan untuk memenuhi kewajiban yang belum terpenuhi.',
              color: HexColor('#5F5F5F'),
            ),
          ),
        ],
      ),
    );
  }

  Widget PenjualanAgunanDone(data, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16.5),
      Wrap(
        spacing: MediaQuery.of(context).size.width / 5,
        children: [
          detailData(
            'Tanggal Pelunasan',
            formatDayDate(data['data_detail']['tanggal_bayar']),
          ),
        ],
      ),
    ]);
  }

  Widget penjualanAguranProsesPencairan(data, argument, BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/process.svg'),
          const SizedBox(height: 32),
          const Headline1(text: 'Sedang Diproses'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Subtitle2(
              text:
                  'Mohon ditunggu ya, pencairan dana ke rekening Anda sedang diproses',
              color: HexColor('#777777'),
              align: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          dividerFull(context),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 94,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Button1(
            btntext: 'Kembali Ke Beranda',
            action: () {
              Navigator.pushNamed(context, HomePage.routeName);
            },
          ),
        ),
      ),
    );
  }

  Widget penjualanAgunanGagal(data, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline5(text: 'Penjualan Agunan'),
        const SizedBox(height: 16.5),
        Wrap(
          spacing: MediaQuery.of(context).size.width / 5,
          children: [
            detailData('Tanggal Terjual',
                dateFormat(data['data_detail']['tanggal_terjual'])),
            detailData('Berat/Karat', '01 Mar 2022 14:00'),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: MediaQuery.of(context).size.width / 7,
          children: [
            detailData('Nominal Penjualan',
                rupiahFormat(data['data_detail']['nominal_penjualan'])),
            data['data_pinjaman']['totalHutang'] >
                    data['data_detail']['nominal_penjualan']
                ? detailData('Sisa penjualan',
                    rupiahFormat(data['data_detail']['sisa_penjualan']))
                : detailDataLihatDokumen(
                    'Dokumen Hasil Penjualan',
                    'Lihat Dokumen',
                    data['data_pinjaman']['fileKuasaJual'],
                    context),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: MediaQuery.of(context).size.width / 6,
          children: [
            data['data_pinjaman']['totalHutang'] <
                    data['data_detail']['nominal_penjualan']
                ? detailDataAgunan('Tidak Tertagih',
                    rupiahFormat(data['data_detail']['tidak_tertagih']))
                : detailDataLihatDokumen(
                    'Dokumen Hasil Penjualan',
                    'Lihat Dokumen',
                    data['data_pinjaman']['fileKuasaJual'],
                    context),
          ],
        ),
      ],
    );
  }

  Widget dokumenPerjanjian(data) {
    final dataDokumen = data['dokumen_perjanjian'];
    // final dataDokumen =
    //     'https://nos.jkt-1.neo.id/appsdanain/document-p2-done/PPB001153.pdf';
    print('dokumen perjanjian $dataDokumen');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Dokumen Perjanjian'),
        const SizedBox(height: 8),
        Button2(
          btntext: 'Lihat Dokumen Perjanjian Pinjaman',
          color: Colors.white,
          textcolor: HexColor(primaryColorHex),
          action: () {
            Navigator.pushNamed(context, DokumenPerjanjianPinjaman.routeName,
                arguments: dataDokumen);
          },
        )
      ],
    );
  }

  Widget waktuPengajuan(data) {
    return Wrap(
      spacing: MediaQuery.of(context).size.width / 5,
      children: [
        detailData('Waktu Pengajuan',
            dateFormatTime(data['data_detail']['waktu_pengajuan'])),
        detailData('Waktu Pencairan',
            dateFormatTime(data['data_detail']['waktu_pencairan'])),
      ],
    );
  }

  Widget imageDetail(BuildContext context, data) {
    final imagePinjaman = data['data_detail']['foto_jaminan'];
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Image.network(
            imagePinjaman == ''
                ? 'assets/images/transaction/detail_pinjaman.png'
                : imagePinjaman,
            fit: BoxFit.fitWidth,
          ),
        );
      },
    );
  }

  Widget totalPinjaman(data) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: HexColor('#E9F6EB')),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Subtitle2(
            text: 'Pinjaman',
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 8),
          Headline1(
            text: rupiahFormat(data['data_detail']['nilai_pinjaman']),
            color: HexColor('#288C50'),
          )
        ],
      ),
    );
  }

  Widget detailPinjaman(data) {
    print('data list data pinjaman ${data['data_detail']}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Positioned(
              top: 40,
              child: dividerFull2(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailData(
                        'Jumlah Barang', data['jumlah_jaminan'].toString()),
                    const SizedBox(height: 24),
                    detailData('Bunga Harian',
                        rupiahFormat(data['data_detail']['bunga_harian'])),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailData('Jatuh Tempo',
                        dateFormat(data['data_detail']['jatuh_tempo'])),
                    const SizedBox(height: 24),
                    detailData('Fee Jasa Mitra Harian',
                        rupiahFormat(data['data_detail']['jasa_mitra_harian'])),
                  ],
                ),
                detailData('Tenor', '${data['data_detail']['tenor']} Hari'),
              ],
            ),
          ],
        ),
        dividerFull2(context),
        detailData('Nama Mitra Penyimpan Emas',
            data['data_detail']['nama_mitra'].toString())
      ],
    );
  }

  Widget agunanWidget(data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Headline3500(text: 'Agunan', color: HexColor('#333333')),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Transform(
            transform: Matrix4.translationValues(0, _expanded ? 0 : 1, 0),
            child: agunanDetail(data),
          ),
          secondChild: Container(
            height: 0, // Shrink the height to zero
          ),
        ),
      ],
    );
  }

  Widget agunanDetail(data) {
    final List<dynamic> listDataJaminan = data['data_jaminan'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Subtitle2(
              text: 'Barang',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 8),
            for (var item in listDataJaminan)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(
                      text: item['nama_jaminan'].toString(),
                      color: HexColor('#333333')),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Subtitle2(
              text: 'Berat',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 8),
            for (var item in listDataJaminan) // Iterate over the same list
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(
                      text: '${item['berat']} gr', color: HexColor('#333333')),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Subtitle2(
              text: 'Karat',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 8),
            for (var item in listDataJaminan) // Iterate over the same list
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(
                      text: '${item['karat']} k', color: HexColor('#333333')),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
          ],
        ),
        // Repeat the similar structure for 'karatAgunan'
      ],
    );
  }

  Widget totalPelunasanWidget(data) {
    print('data riwayat ${data['data_pinjaman']}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _expandedPelunasan = !_expandedPelunasan;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(
                    text: 'Total Pelunasan',
                    color: HexColor('#A3A3A3'),
                  ),
                  const SizedBox(height: 8),
                  Headline2600(
                      text: rupiahFormat(
                          data['data_pinjaman']?['totalHutang'] ?? 0)),
                ],
              ),
              Icon(
                _expandedPelunasan ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _expandedPelunasan
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Transform(
            transform:
                Matrix4.translationValues(0, _expandedPelunasan ? 0 : 1, 0),
            child: totalPelunasanDetail(data),
          ),
          secondChild: Container(
            height: 0, // Shrink the height to zero
          ),
        ),
      ],
    );
  }

  Widget totalPelunasanDetail(data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        keyVal(
            'Pokok', rupiahFormat(data['data_pinjaman']?['saldo_pokok'] ?? 0)),
        const SizedBox(height: 12),
        keyVal('Bunga Terhutang',
            rupiahFormat(data['data_pinjaman']?['bungaTerhutang'] ?? 0)),
        const SizedBox(height: 12),
        keyVal('Fee Jasa Mitra Terhutang',
            rupiahFormat(data['data_pinjaman']?['jasaMitraTerhutang'] ?? 0)),
        const SizedBox(height: 12),
        keyVal('Denda Keterlambatan',
            rupiahFormat(data['data_pinjaman']?['total_denda'] ?? 0)),
        const SizedBox(height: 12),
      ],
    );
  }
}

Widget detailData(String title, String val) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle3(
        text: title,
        color: HexColor('#AAAAAA'),
        align: TextAlign.right,
      ),
      const SizedBox(height: 8),
      TextWidget(
        text: val,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: HexColor('#333333'),
        align: TextAlign.right,
      ),
    ],
  );
}

Widget detailDataPendanaanLender(String title, String val) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle3(
        text: title,
        color: HexColor('#AAAAAA'),
      ),
      const SizedBox(height: 4),
      Subtitle2Extra(
        text: val,
        color: HexColor('#333333'),
        fWeight: FontWeight.w500,
      ),
    ],
  );
}

Widget detailDataAgunan(String title, String val) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(
        text: title,
        color: HexColor('#777777'),
      ),
      const SizedBox(height: 8),
      Subtitle2(
        text: val,
        color: HexColor('#EB5757'),
      ),
    ],
  );
}

Widget detailDataLihatDokumen(
    String title, String val, data, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(
        text: title,
        color: HexColor('#777777'),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DokumenPerjanjianPinjaman.routeName,
              arguments: data);
        }, // Specify the onTap callback
        child: Subtitle2(
          text: val,
          color: HexColor('#27AE60'),
        ),
      ),
    ],
  );
}
