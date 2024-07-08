import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class DataDiriPage extends StatefulWidget {
  final VerifikasiBloc verifBloc;
  const DataDiriPage({super.key, required this.verifBloc});

  @override
  State<DataDiriPage> createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousTitleCustom(context, 'Data Diri', () {
        Navigator.pop(context);
      }),
      body: successScreen(context),
      bottomNavigationBar: Container(
        height: 200,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Button1(
              btntext: 'Mulai',
              color: HexColor(lenderColor),
              action: () {
                widget.verifBloc.stepControl(1);
              },
            ),
            const SizedBox(height: 16),
            Button1(
              btntext: 'Kembali ke Beranda',
              textcolor: HexColor(lenderColor),
              color: Colors.white,
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
}

Widget successScreen(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.only(top: 60),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/lender/verifikasi/data_diri.svg'),
          const SizedBox(height: 24),
          const Headline2(text: 'Pengisian Data Diri'),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Sebelum mulai siapkan KTP, NPWP serta pastikan koneksi internet dalam kondisi stabil',
            color: HexColor('#777777'),
            align: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
