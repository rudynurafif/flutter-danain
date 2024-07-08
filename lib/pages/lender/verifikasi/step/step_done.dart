import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_bloc.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepDoneVerifikasi extends StatelessWidget {
  final VerifikasiBloc verifBloc;
  const StepDoneVerifikasi({super.key, required this.verifBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/lender/verifikasi/scan_data.svg'),
            const SizedBox(height: 24),
            const Headline2(
              text: 'Dokumen Anda Sedang dalam Verifikasi',
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Subtitle2(
              text:
                  'Data Anda sedang dalam verifikasi. Proses verifikasi maksimal 1x24 jam hari kerja',
              align: TextAlign.center,
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Button1(
              btntext: 'Kembali ke Menu Utama',
              action: () {
                Navigator.pushNamed(context, HomePageLender.routeNeme);
              },
            ),
          ],
        ),
      ),
    );
  }
}
