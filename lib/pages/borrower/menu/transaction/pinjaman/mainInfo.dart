import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/transaction_page.dart';
import 'package:flutter_danain/widgets/rupiah_format.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class MainInfo extends StatelessWidget {
  final int pinjamanAktif;
  final int tagihanBulanIni;
  const MainInfo(
      {super.key, required this.pinjamanAktif, required this.tagihanBulanIni});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/transaction/background_transaksi_3.svg',
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tagihan
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tagihan Bulan Ini',
                      style: TextStyle(color: Color(0xff777777), fontSize: 12),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: TextWidget(
                        text: rupiahFormat(pinjamanAktif),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // divider
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: DividerContent(
                  color: HexColor(primaryColorHex),
                  width: 2,
                  height: 40,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              // pinjaman
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pinjaman Aktif',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                      text: rupiahFormat(tagihanBulanIni),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DividerContent extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const DividerContent({
    super.key,
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}
