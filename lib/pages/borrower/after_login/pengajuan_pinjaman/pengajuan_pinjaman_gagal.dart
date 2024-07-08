import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PengajuanPinjamanGagal extends StatelessWidget {
  const PengajuanPinjamanGagal({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/transaction/gagal_cicil.svg'),
              const SizedBox(
                height: 20,
              ),
              const Headline2(
                text: 'Pengajuan Pinjaman Gagal',
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle1(
                text:
                    'Mohon maaf saat ini Anda belum dapat melakukan pengajuan pinjaman. Silakan coba kembali lain waktu.',
                color: HexColor('#777777'),
                align: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Button1(
                btntext: 'Kembali Ke Beranda',
                action: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomePage.routeName,
                    (route) => false,
                  );
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Subtitle2(
                text: 'Perlu informasi lebih lanjut?',
                color: HexColor('#5F5F5F'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Subtitle2(
                    text: 'Kunjungi',
                    color: HexColor('#5F5F5F'),
                  ),
                  const SizedBox(width: 2),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        HelpTemporary.routeName,
                      );
                    },
                    child: Headline5Extra(
                      text: 'Bantuan',
                      color: HexColor(primaryColorHex),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
          (route) => false,
        );
        return false;
      },
    );
  }
}
