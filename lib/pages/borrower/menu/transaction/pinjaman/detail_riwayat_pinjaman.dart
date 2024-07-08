import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailRiwayatPinjaman extends StatefulWidget {
  static const routeName = '/detail_riwayat_pinjaman';
  const DetailRiwayatPinjaman({super.key});

  @override
  State<DetailRiwayatPinjaman> createState() => _DetailRiwayatPinjamanState();
}

class _DetailRiwayatPinjamanState extends State<DetailRiwayatPinjaman> {
  List<String> barangAgunan = [
    'Cincin',
    'Gelang',
  ];
  List<String> beratAgunan = [
    '10 gr',
    '3 gr',
  ];
  List<String> karatAgunan = [
    '24k',
    '25k',
  ];

  bool _expanded = false;
  bool _expandedPelunasan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        elevation: 0,
        title: const Column(
          children: [
            Headline2500(text: 'Detail Pinjaman'),
            SizedBox(height: 8),
            Subtitle3(text: 'No. 202111125000378')
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageDetail(context),
              totalPinjaman(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: detailPinjaman(),
              ),
              dividerFull(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: agunanWidget(),
              ),
              dividerFull(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: totalPelunasanWidget(),
              ),
              dividerFull(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: dokumenPerjanjian(),
              ),
              dividerFull(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: waktuPengajuan(),
              ),
              dividerFull(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Button1(
                  btntext: 'Bayar Pinjaman',
                  action: () {
                    Navigator.pushNamed(context, PembayaranPage.routeName);
                  },
                ),
              ),
              const SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }

  Widget dokumenPerjanjian() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Dokumen Perjanjian'),
        const SizedBox(height: 8),
        Button2(
          btntext: 'Lihat Dokumen Perjanjian Pinjaman',
          color: Colors.white,
          textcolor: HexColor(primaryColorHex),
          action: () {},
        )
      ],
    );
  }

  Widget waktuPengajuan() {
    return Wrap(
      spacing: MediaQuery.of(context).size.width / 5,
      children: [
        detailData('Waktu Pengajuan', '01 Mar 2022 14:00'),
        detailData('Waktu Pencairan', '01 Mar 2022 14:00'),
      ],
    );
  }

  Widget imageDetail(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Image.asset(
            'assets/images/transaction/detail_pinjaman.png',
            fit: BoxFit.fitWidth,
          ),
        );
      },
    );
  }

  Widget totalPinjaman() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: HexColor('#E9F6EB')),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Subtitle2(
            text: 'Pinjaman',
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 8),
          Headline1(
            text: rupiahFormat(7000000),
            color: HexColor(primaryColorHex),
          )
        ],
      ),
    );
  }

  Widget detailPinjaman() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Positioned(
              child: dividerFull2(context),
              top: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailData('Jumlah Barang', '2'),
                    const SizedBox(height: 16),
                    detailData('Bunga Harian', rupiahFormat(3306)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailData('Jatuh Tempo', '23 Apr 2023'),
                    const SizedBox(height: 16),
                    detailData('Fee Jasa Mitra Harian', rupiahFormat(1809)),
                  ],
                ),
                detailData('Tenor', '150 hari'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 25),
        detailData('Nama Mitra Penyimpan Emas',
            'Gadai Mas DKI Jakarta Cabang Kalisari')
      ],
    );
  }

  Widget agunanWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Headline3500(text: 'Agunan'),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Transform(
            transform: Matrix4.translationValues(0, _expanded ? 0 : 1, 0),
            child: agunanDetail(),
          ),
          secondChild: Container(
            height: 0, // Shrink the height to zero
          ),
        ),
      ],
    );
  }

  Widget agunanDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Subtitle2(
              text: 'Barang',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 8),
            for (String item in barangAgunan)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(text: item),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle2(
              text: 'Berat',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 8),
            for (String item in beratAgunan)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(text: item),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle2(
              text: 'karat',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 8),
            for (String item in karatAgunan)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(text: item.toString()),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
          ],
        ),
      ],
    );
  }

  Widget totalPelunasanWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedPelunasan = !_expandedPelunasan;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(
                    text: 'Total Pelunasan',
                    color: HexColor('#777777'),
                  ),
                  const SizedBox(height: 8),
                  Headline3500(text: rupiahFormat(750000)),
                ],
              ),
              Icon(
                _expandedPelunasan ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _expandedPelunasan
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Transform(
            transform:
                Matrix4.translationValues(0, _expandedPelunasan ? 0 : 1, 0),
            child: totalPelunasanDetail(),
          ),
          secondChild: Container(
            height: 0, // Shrink the height to zero
          ),
        ),
      ],
    );
  }

  Widget totalPelunasanDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        keyVal('Pokok', rupiahFormat(7000000)),
        const SizedBox(height: 12),
        keyVal('Bunga Terhutang', rupiahFormat(33056)),
        const SizedBox(height: 12),
        keyVal('Fee Jasa Mitra Terhutang', rupiahFormat(18000)),
        const SizedBox(height: 12),
        keyVal('Denda Keterlambatan', rupiahFormat(0)),
        const SizedBox(height: 12),
      ],
    );
  }
}

Widget detailData(String title, String val) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle2(
        text: title,
        color: HexColor('#777777'),
      ),
      const SizedBox(height: 8),
      Subtitle2(text: val),
    ],
  );
}
