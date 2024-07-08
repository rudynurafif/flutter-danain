import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../home/home_page.dart';
import 'detail_riwayat_pinjaman_bloc.dart';

class DetailRiwayatPinjamanProsesPage extends StatefulWidget {
  static const routeName = '/detail_riwayat_pinjaman_proses_page';
  const DetailRiwayatPinjamanProsesPage({super.key});

  @override
  State<DetailRiwayatPinjamanProsesPage> createState() =>
      _DetailRiwayatPinjamanProsesPageState();
}

class _DetailRiwayatPinjamanProsesPageState
    extends State<DetailRiwayatPinjamanProsesPage> {
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
  @override
  void initState() {
    super.initState();
    // Delay the code execution to ensure initState has completed
    Future.delayed(Duration.zero, () {
      final detailPengajuanBloc =
          BlocProvider.of<DetailRiwayatPinjamanBloc>(context);
      final dynamic argument = ModalRoute.of(context)!.settings.arguments;
      print('argument id $argument');
      detailPengajuanBloc.idAggrementChange(argument);
      detailPengajuanBloc.detailPinjamanChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailPengajuanBloc =
        BlocProvider.of<DetailRiwayatPinjamanBloc>(context);

    final dynamic argument = ModalRoute.of(context)!.settings.arguments;
    print('argument id $argument');
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: pinjamanDetail(detailPengajuanBloc),
          ),
          const SizedBox(height: 8),
          dividerFull(context),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: Container(
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

  Widget pinjamanDetail(DetailRiwayatPinjamanBloc detailPengajuanBloc) {
    return StreamBuilder(
      stream: detailPengajuanBloc.messageDetailPinjamanStream$,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Detail Pencairan Pinjaman'),
              const SizedBox(height: 16),
              keyValLoading(context),
              const SizedBox(height: 8),
              keyValLoading(context),
              const SizedBox(height: 8),
              keyValLoading(context),
              const SizedBox(height: 8),
              keyValLoading(context),
              const SizedBox(height: 8),
              keyValLoading(context),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Detail Pencairan Pinjaman'),
              const SizedBox(height: 16),
              keyVal('Pinjaman', rupiahFormat(data['totalPembayaran'])),
              const SizedBox(height: 8),
              keyVal2Modified(
                  'Rekening Tujuan', data['rekeningTujuanBorrower']),
              const SizedBox(height: 8),
              keyVal('Biaya Administrasi', rupiahFormat(data['biayaAdmin'])),
              const SizedBox(height: 8),
              keyVal2('Total Pencairan', rupiahFormat(data['totalPencairan'])),
              const SizedBox(height: 8),
              keyVal('Waktu Pengajuan', formatDateFull2(data['createdAt'])),
            ],
          );
        }
      },
    );
  }
}
