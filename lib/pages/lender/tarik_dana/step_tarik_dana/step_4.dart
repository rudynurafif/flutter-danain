import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/tarik_dana/tarik_dana.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter_danain/utils/utils.dart';

class Step4TarikDana extends StatefulWidget {
  final TarikDanaBloc tdBloc;
  const Step4TarikDana({super.key, required this.tdBloc});

  @override
  State<Step4TarikDana> createState() => _Step4TarikDanaState();
}

class _Step4TarikDanaState extends State<Step4TarikDana> {
  String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('E, d MMM y, HH:mm');
    return dateFormat.format(date);
  }

  String formatDate2(DateTime date) {
    final DateFormat dateFormat = DateFormat('d MMM y');
    return dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.tdBloc;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 66),
            SvgPicture.asset('assets/lender/tarikDana/tarik_dana_proses.svg'),
            const SizedBox(height: 32),
            const Headline1(text: 'Tarik Dana Sedang Diproses'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Subtitle2(
                text:
                    'Pengiriman dana ke rekening Anda paling lambat akan masuk pada Hari ${formatDayInd(DateTime.now().add(const Duration(days: 1)).toString())} tanggal ${dateFormat(DateTime.now().add(const Duration(days: 1)).toString())}',
                color: HexColor('#777777'),
                align: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            dividerFull(context),
            detail(bloc)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Button1(
              btntext: 'Kembali Ke Halaman Utama',
              color: HexColor(lenderColor),
              action: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomePageLender.routeNeme,
                  (route) => false,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget detail(TarikDanaBloc bloc) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: bloc.responseTarikDana,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Headline3500(text: 'Detail Penarikan Dana'),
                const SizedBox(height: 16),
                keyVal2('Penarikan Dana', rupiahFormat(data['nominal'] ?? 0)),
                const SizedBox(height: 8),
                keyVal2('Rekening Tujuan', data['rekTujuan'] ?? ''),
                const SizedBox(height: 8),
                keyVal(
                  'Biaya Transaksi',
                  rupiahFormat(data['biayaTransaksi'] ?? 0),
                ),
                const SizedBox(height: 8),
                keyVal(
                  'Waktu Penarikan',
                  formatDateFull(
                    data['date'] ?? '',
                  ),
                )
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerLong(height: 16, width: 140),
              const SpacerV(value: 16),
              keyValLoading(context),
              const SpacerV(value: 8),
              keyValLoading(context),
              const SpacerV(value: 8),
              keyValLoading(context),
              const SpacerV(value: 8),
              keyValLoading(context),
            ],
          ),
        );
      },
    );
  }
}
