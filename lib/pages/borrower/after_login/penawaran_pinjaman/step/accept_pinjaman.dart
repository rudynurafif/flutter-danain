import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_bloc2.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class AcceptPinjaman extends StatefulWidget {
  final PenawaranPinjamanBloc2 ppBloc;
  const AcceptPinjaman({super.key, required this.ppBloc});

  @override
  State<AcceptPinjaman> createState() => _AcceptPinjamanState();
}

class _AcceptPinjamanState extends State<AcceptPinjaman> {
  String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('E, d MMM y, HH:mm');
    return dateFormat.format(date);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bodyBuilder(context);
  }

  Widget bodyBuilder(BuildContext context) {
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
          StreamBuilder<Map<String, dynamic>>(
            stream: widget.ppBloc.responseData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? {};
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: pinjamanDetail(data),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 94,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Button1(
            btntext: 'Kembali Ke Beranda',
            action: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName, (Route<dynamic> route) => false);
            },
          ),
        ),
      ),
    );
  }

  Widget pinjamanDetail(Map<String, dynamic> data) {
    // final dataBank = data['data_bank'];
    print('test detail data $data');
    // final dataJaminan = data['jaminans'];
    // final dataPinjaman = data['pinjaman'];
    // String bank = '${dataBank['nama_bank']} - ${dataBank['no_rekening']}';
    DateTime waktu = DateTime.parse(data['waktu']);
    double biayaAdmin = data['biaya_admin'].toDouble();
    double totalPencairan = data['total_pencairan'].toDouble();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Detail Pencairan Pinjaman'),
        const SizedBox(height: 16),
        keyVal('Pinjaman', rupiahFormat(data['pinjaman_nominal'])),
        const SizedBox(height: 8),
        keyVal2('Rekening Tujuan', data['rekening_tujuan']),
        const SizedBox(height: 8),
        keyVal('Biaya Administrasi', rupiahFormat(biayaAdmin.toInt())),
        const SizedBox(height: 8),
        cashBackControl(data['cash_back']),
        keyVal2('Total Pencairan', rupiahFormat(totalPencairan.toInt())),
        const SizedBox(height: 8),
        keyVal('Waktu Pengajuan', formatDateFull(waktu.toString())),
      ],
    );
  }

  Widget cashBackControl(int cashBack) {
    if (cashBack == 0) {
      return const SizedBox.shrink();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          keyVal('Cashback Pinjaman', rupiahFormat(cashBack)),
          const SizedBox(height: 8),
        ],
      );
    }
  }
}
