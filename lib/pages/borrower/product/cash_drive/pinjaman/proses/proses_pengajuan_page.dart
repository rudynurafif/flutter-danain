import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/component/home/action_modal_component.dart';
import 'package:flutter_danain/component/home/verif_component.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/proses/proses_pengajuan_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/simulasi/simulasi_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class ProsesPengajuanPage extends StatefulWidget {
  static const routeName = '/proses_pengajuan_page';
  const ProsesPengajuanPage({
    super.key,
  });

  @override
  State<ProsesPengajuanPage> createState() => _ProsesPengajuanPageState();
}

class _ProsesPengajuanPageState extends State<ProsesPengajuanPage> {
  final ScrollController _scrollController = ScrollController();
  void mainanGan() {
    // Get the current date
    final DateTime currentDate = DateTime.now();

    // Get the previous month
    // Subtract one month from the current date
    final DateTime previousMonth =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

    // Format the previous month
    final String formattedPreviousMonth =
        DateFormat('MM YYYY').format(previousMonth);

    // Get the current year
    final int currentYear = currentDate.year;

    print('Previous Month: $formattedPreviousMonth');
    print('Current Year: $currentYear');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<ProsesPengajuanBloc>(context);
    bloc.getDataDetail();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bloc.infiniteScroll();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    mainanGan();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ProsesPengajuanBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {
        return bloc.getDataDetail();
      },
      child: Scaffold(
        appBar: previousTitleCustom(context, 'Proses Pengajuan', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: StreamBuilder<List<dynamic>?>(
            stream: bloc.listData,
            builder: (context, snapshot) {
              final List<dynamic> dataList = snapshot.data ?? [];

              if (snapshot.hasData) {
                if (dataList.isEmpty || snapshot.data == null) {
                  return notFound(bloc);
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerV(value: 16),
                    listData(dataList),
                  ],
                );
              } else {
                if (dataList.isEmpty || snapshot.data == null) {
                  return notFound(bloc);
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget notFound(ProsesPengajuanBloc bloc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SpacerV(value: 100),
          SvgPicture.asset('assets/images/transaction/no_transaction.svg'),
          const SizedBox(height: 33),
          const Headline2(
            text: 'Anda Belum Memiliki Pengajuan',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Saat ini Anda belum memiliki transaksi pengajuan pinjaman. Ajukan pinjaman Anda sekarang juga.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          ),
          const SizedBox(height: 24),
          StreamBuilder<Map<String, dynamic>?>(
            stream: bloc.beranda,
            builder: (context, snapshot) {
              final beranda = snapshot.data ?? {};
              final status = beranda['status'] ?? {};
              return ButtonWidget(
                title: 'Ajukan Pinjaman',
                onPressed: () {
                  // if (status['aktivasi_status'] != 10) {
                  //   if (status['aktivasi_status'] == 9) {
                  //     showVerifikasiAlert(context);
                  //     return;
                  //   }
                  //   if (status['aktivasi_status'] == 0) {
                  //     showHaventVerifAlert(context);
                  //     return;
                  //   }
                  //   if (status['aktivasi_status'] == 11) {
                  //     showHaventVerifAlert(context);
                  //     return;
                  //   }
                  //   if (status['aktivasi_status'] == 12) {
                  //     showRejectPrivyAlert(context);
                  //     return;
                  //   }
                  //   return;
                  // }
                  // if (status['bank'] == false) {
                  //   showAktivasiAlert(context);
                  //   return;
                  // }
                  // if (status['status_request_hp'] == 'waiting' ||
                  //     status['status_request_email'] == 'waiting') {
                  //   showVerifikasiAlert(context);
                  //   return;
                  // }

                  if (status['is_keluarga'] == 0 ||
                      status['is_pasangan'] == 0) {
                    showKontakDaruratAlert(context);
                    return;
                  }
                  if (status['is_pengajuan_pinjaman'] > 0) {
                    showHavePengajuan(context);
                    return;
                  }

                  Navigator.pushNamed(
                    context,
                    SimulasiCashDrivePage.routeName,
                    arguments: SimulasiCashDriveParams(
                      isPengajuan: true,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  ListView listData(List<dynamic> dataList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final d = dataList[index];
        return DetailProsesPengajuanComponent(
          idTask: d['noPerjanjian'].toString(),
          jumlahPinjaman: d['nilaiPinjaman'],
          status: '-',
          alamatUtama: d['alamatDomisiliPin'] ?? '',
          alamatDetail: d['detailAlamat'],
          tglSurvey: d['tglPengajuan'].toString(),
          onTap: () {
            Navigator.pushNamed(
              context,
              KonfirmasJadwalSurveyPage.routeName,
              arguments: KonfirmasJadwalSurveyPage(
                idTaskPengajuan: d['idTaskPengajuan'] ?? 0,
                idPengajuan: d['idPengajuan'] ?? 0,
              ),
            );
          },
          isStatus: 1,
          jenisKendaraan: d['idJenisKendaraan'],
        );
      },
    );
  }

  Widget noTransactionWidget(
    BuildContext context,
    statusBank,
    username,
    status,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/no_message.svg'),
          const SizedBox(height: 8),
          const Headline2(
            text: 'Belum Ada Pengajuan',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle1(
            text:
                'Anda belum memiliki riwayat Proses Pengajuan.Mulailah bertransaksi untuk melihat semua daftar Pengajuan di sini',
            align: TextAlign.center,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
