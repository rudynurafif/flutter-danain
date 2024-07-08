import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/mainInfo.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pinjaman_menu.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../domain/models/app_error.dart';
import '../../../../domain/models/auth_state.dart';
import 'cicilan/cicil_emas_transaction_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionPage extends StatefulWidget {
  final HomeBloc homeBloc;
  final int index;
  const TransactionPage(
      {super.key, required this.homeBloc, required this.index});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Headline2500(text: 'Transaksi Lama'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          shadowColor: Colors.black,
          elevation: 0,
          toolbarHeight: 72,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(26, 158, 158, 158),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                          spreadRadius: 4,
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Card tagihan bulan ini | pinjaman aktif
                MainInfo(
                  pinjamanAktif: 1,
                  tagihanBulanIni: 1,
                ),

                SizedBox(
                  height: 24,
                ),

                // proses pengajuan
                ProsesPengajuan(),

                SizedBox(
                  height: 24,
                ),

                // Riwayat pinjaman
                RiwayatPinjaman(),
              ],
            ),
          ),
        ));
  }
}

class ProsesPengajuan extends StatelessWidget {
  const ProsesPengajuan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xffEEEEEE),
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SvgPicture.asset(
                    'assets/images/transaction/proses_pengajuan.svg',
                    colorFilter: ColorFilter.mode(
                        HexColor(primaryColorHex), BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                ),
                const Text(
                  'Proses Pengajuan',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
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
