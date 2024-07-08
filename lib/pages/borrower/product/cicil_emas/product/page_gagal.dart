import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PengajuanCicilanGagal extends StatelessWidget {
  static const routeName = '/cicil_emas_gagal';
  const PengajuanCicilanGagal({super.key});

  @override
  Widget build(BuildContext context) {
    final entryValue = ModalRoute.of(context)?.settings.arguments as String?;
    print(entryValue);

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
              Headline2(
                text: entryValue == 'pinjaman'
                    ? 'Pengajuan Pinjaman Gagal'
                    : 'Pengajuan Cicil Emas Gagal',
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle1(
                text: entryValue == 'pinjaman'
                    ? 'Mohon maaf saat ini Anda belum dapat melakukan pengajuan pinjaman. Silakan coba kembali lain waktu.'
                    : 'Ups! Saat ini Anda belum bisa melakukan cicil emas. Jangan khawatir, coba lagi di lain waktu dan wujudkan rencana masa depan Anda.',
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
          padding: EdgeInsets.all(16),
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
                  SizedBox(width: 2),
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
