import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../pages/borrower/home/home_page.dart';

class BtmSheetPenyerahan extends StatelessWidget {
  const BtmSheetPenyerahan(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 90,
                  height: 4,
                  color: HexColor('#DDDDDD'),
                ),
              ),
              const SizedBox(height: 24),
              const Headline2500(text: 'Konfirmasi Penyerahan BPKB'),
              const SizedBox(height: 8),
              Headline4500(
                  text:
                      'Pastikan foto surveyor dan data kendaraan yang ditampilkan sesuai',
                  color: HexColor('##777777')),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/home/peminjam_bpkb.png',
                ),
              ),
              const SizedBox(height: 24),
              Button1(
                btntext: 'Konfirmasi',
                action: () {
                  Navigator.pushNamed(context, HomePage.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
