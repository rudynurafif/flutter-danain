// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_danain/component/introduction/contentmenu_component.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/simulasi_cicilan_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/pinjaman/simulasi_pinjaman.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class SimulasiChoosePage extends StatefulWidget {
  static const routeName = '/simulasi_page';
  final int? statusAktivasi;
  final String? hp;
  final String? email;
  final bool? pekerjaan;
  const SimulasiChoosePage({
    super.key,
    this.statusAktivasi,
    this.email,
    this.hp,
    this.pekerjaan,
  });

  @override
  State<SimulasiChoosePage> createState() => _SimulasiChoosePageState();
}

class _SimulasiChoosePageState extends State<SimulasiChoosePage> {
  int aktivasi = 0;
  String statusHp = 'waiting';
  String statusEmail = 'waiting';
  bool pekerjaanStatus = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as SimulasiChoosePage?;
    if (args != null && args.statusAktivasi != null) {
      setState(() {
        aktivasi = args.statusAktivasi!;
      });
      print(aktivasi);
    }
    if (args != null && args.hp != null) {
      setState(() {
        statusHp = args.hp!;
      });
    }
    if (args != null && args.email != null) {
      setState(() {
        statusEmail = args.email!;
      });
    }
    if (args != null && args.pekerjaan != null) {
      setState(() {
        pekerjaanStatus = args.pekerjaan!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Simulasi'),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline2500(text: 'Simulasi'),
            const SizedBox(height: 8),
            Subtitle2(
              text:
                  'Dapatkan informasi simulasi sesuai produk yang Anda inginkan',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: HexColor('#EEEEEE'))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: contentPinjaman(),
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: HexColor('#EEEEEE'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: contentCicilan(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contentPinjaman() {
    return ContentMenu(
      image: 'assets/images/preference/simulasi_pinjaman.svg',
      title: 'Simulasi Pinjaman',
      subtitle: 'Hitung dan dapatkan informasi pinjaman yang Anda butuhkan',
      icon: true,
      navigate: () {
        Navigator.pushNamed(context, SimulasiPinjaman.routeName);
      },
    );
  }

  Widget contentCicilan() {
    return ContentMenu(
      image: 'assets/images/preference/simulasi_cicilan.svg',
      title: 'Simulasi Cicilan',
      subtitle: 'Hitung dan dapatkan informasi angsuran yang Anda ajukan',
      icon: true,
      navigate: () {
        Navigator.pushNamed(
          context,
          SimulasiCicilanEmas.routeName,
          arguments: SimulasiCicilanEmas(
            statusLogin: true,
            statusAktivasi: aktivasi,
            email: statusEmail,
            hp: statusHp,
            pekerjaan: pekerjaanStatus,
          ),
        );
      },
    );
  }
}
