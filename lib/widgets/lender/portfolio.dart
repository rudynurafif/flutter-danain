import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_danain/utils/utils.dart';

import '../widget_element.dart';

class WidgetDetailPortfolio extends StatefulWidget {
  final String image;
  final num jumlahPendanaan;
  final num nilaiPengembalian;
  final String namaProduk;
  final String deskripsiProduk;
  final num bunga;
  final num tenor;
  final List<dynamic> agunan;
  final String mitra;
  final String nama;
  final num score;
  final num bungaRp;
  final num danaPokok;

  //content not required
  final String? jatuhTempo;
  final String? mulaiPendanaan;
  final num? terlambat;
  final String? tujuanPinjaman;
  final String? statusPendanaan;
  final Map<String, dynamic>? dataList;
  final Map<String, dynamic>? dataDetail;
  final String? tanggalLunas;
  const WidgetDetailPortfolio({
    super.key,
    required this.image,
    required this.jumlahPendanaan,
    required this.nilaiPengembalian,
    required this.namaProduk,
    required this.deskripsiProduk,
    required this.bunga,
    required this.tenor,
    required this.agunan,
    required this.mitra,
    required this.nama,
    required this.score,
    required this.bungaRp,
    required this.danaPokok,
    this.jatuhTempo,
    this.mulaiPendanaan,
    this.terlambat,
    this.tujuanPinjaman,
    this.statusPendanaan,
    this.dataList,
    this.dataDetail,
    this.tanggalLunas,
  });

  @override
  State<WidgetDetailPortfolio> createState() => _WidgetDetailPortfolioState();
}

class _WidgetDetailPortfolioState extends State<WidgetDetailPortfolio> {
  bool expand = false;
  void getPotensiPembayaran() {
    showDialog(
      context: context,
      builder: (context) {
        return ModalDetailAngsuran(
          content: potensiPengembalian(),
        );
      },
    );
  }

  void getTotalPembayaran() {
    showDialog(
      context: context,
      builder: (context) {
        return ModalDetailAngsuran(
          content: totalPengembalian(),
        );
      },
    );
  }

  void getDijualPembayaran() {
    showDialog(
      context: context,
      builder: (context) {
        return ModalDetailAngsuran(
          content: pengembalianDijual(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('check pembulatan ${widget.nilaiPengembalian}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Image.network(
                widget.image,
                fit: BoxFit.fitHeight,
                height: 300,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      color: HexColor('#EEEEEE'),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    widget.namaProduk.startsWith('C')
                        ? 'assets/lender/pendanaan/cicil_emas_2.png'
                        : 'assets/lender/pendanaan/pendanaan_default.png',
                    fit: BoxFit.fitHeight,
                    height: 300,
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Subtitle3(
                      text: 'Jumlah Pendanaan',
                      color: HexColor('#777777'),
                    ),
                    const SizedBox(height: 8),
                    Headline3500(
                      text: rupiahFormat(widget.jumlahPendanaan),
                      color: HexColor(lenderColor),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 45,
                width: 2,
                color: HexColor('#EEEEEE'),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Subtitle3(
                        text: widget.statusPendanaan != null &&
                                (widget.statusPendanaan?.toLowerCase() ==
                                        'lunas' ||
                                    widget.statusPendanaan?.toLowerCase() ==
                                        'dijual' ||
                                    widget.statusPendanaan?.toLowerCase() ==
                                        'selesai')
                            ? 'Total Pengembalian '
                            : 'Potensi Pengembalian ',
                        color: HexColor('#777777'),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.statusPendanaan != null &&
                              widget.statusPendanaan?.toLowerCase() ==
                                  'lunas') {
                            getTotalPembayaran();
                          } else if (widget.statusPendanaan != null &&
                              widget.statusPendanaan?.toLowerCase() ==
                                  'selesai') {
                            getDijualPembayaran();
                          } else {
                            getPotensiPembayaran();
                          }
                        },
                        child: Transform.rotate(
                          angle: 3.14159265,
                          child: Icon(
                            Icons.error,
                            color: HexColor(lenderColor),
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Headline3500(
                    text: rupiahFormat(widget.nilaiPengembalian),
                    color: HexColor(lenderColor),
                  )
                ],
              )
            ],
          ),
        ),
        dividerFull(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline3500(text: widget.namaProduk),
              const SizedBox(height: 8),
              Subtitle3(
                text: widget.deskripsiProduk,
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: widget.jatuhTempo != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle3(
                        text: 'Bunga',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      Subtitle2Extra(text: '${widget.bunga.toString()}% p.a'),
                      if (widget.mulaiPendanaan != null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Subtitle3(
                              text: 'Mulai Pendanaan',
                              color: HexColor('#AAAAAA'),
                            ),
                            const SizedBox(height: 4),
                            Subtitle2Extra(text: widget.mulaiPendanaan!)
                          ],
                        ),
                    ],
                  ),
                  if (widget.jatuhTempo == null) const SizedBox(width: 80),
                  if (widget.jatuhTempo != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle3(
                          text: 'Jatuh Tempo',
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(height: 4),
                        Subtitle2Extra(text: widget.jatuhTempo!),
                        if (widget.terlambat != null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Subtitle3(
                                text: 'Terlambat',
                                color: HexColor('#AAAAAA'),
                              ),
                              const SizedBox(height: 4),
                              Subtitle2Extra(text: '${widget.terlambat} hari')
                            ],
                          ),
                        if (widget.terlambat == null &&
                            widget.tanggalLunas != null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Subtitle3(
                                text: 'Tanggal Lunas',
                                color: HexColor('#AAAAAA'),
                              ),
                              const SizedBox(height: 4),
                              Subtitle2Extra(
                                  text: dateFormat(widget.tanggalLunas!))
                            ],
                          ),
                      ],
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle3(
                        text: 'Tenor',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      Subtitle2Extra(
                          text:
                              '${widget.tenor.toString()} ${widget.namaProduk.startsWith('C') ? 'Bulan' : 'Hari'}'),
                      if (widget.terlambat != null &&
                          widget.tanggalLunas != null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Subtitle3(
                              text: 'Tanggal Lunas',
                              color: HexColor('#AAAAAA'),
                            ),
                            const SizedBox(height: 4),
                            Subtitle2Extra(
                                text: dateFormat(widget.tanggalLunas!))
                          ],
                        ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        dividerFull(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                expand = !expand;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Headline3500(text: 'Agunan'),
                Icon(
                  expand ? Icons.expand_less : Icons.expand_more,
                  color: HexColor('#AAAAAA'),
                  size: 24,
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: expand,
          child: expand ? agunanWidget(widget.agunan) : const SizedBox.shrink(),
        ),
        dividerFull(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Mitra Gadai'),
              const SizedBox(height: 8),
              Subtitle2(
                text: widget.mitra,
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        dividerFull(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Info Peminjam'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle3(
                        text: 'Nama Peminjam',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      Subtitle2Extra(text: widget.nama)
                    ],
                  ),
                  const SizedBox(width: 70),
                  // if (widget.namaProduk.startsWith('C'))
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Subtitle3(
                  //           text: 'Skor Kredit ',
                  //           color: HexColor('#AAAAAA'),
                  //         ),
                  //         InkWell(
                  //           onTap: () {
                  //             showDialog(
                  //               context: context,
                  //               builder: (context) => ModalDetailAngsuran(
                  //                 content: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     const Subtitle2Extra(text: 'Skor Kredit'),
                  //                     const SizedBox(height: 8),
                  //                     Subtitle3(
                  //                       color: HexColor('#777777'),
                  //                       text:
                  //                           'Skor kredit merupakan sistem penilaian yang diterapkan Danain untuk melihat kemampuan peminjam dalam melunasi pinjamannya. Semakin mendekati skor tertinggi di angka 200 semakin baik reputasi peminjam.',
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //           child: Transform.rotate(
                  //             angle: 3.14159265,
                  //             child: Icon(
                  //               Icons.error,
                  //               color: HexColor(lenderColor),
                  //               size: 14,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(height: 4),
                  //     Subtitle2Extra(text: '${widget.score}/200')
                  //   ],
                  // ),
                  if (widget.tujuanPinjaman != null &&
                      widget.namaProduk.startsWith('M'))
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle3(
                          text: 'Tujuan',
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(height: 4),
                        Subtitle2Extra(text: widget.tujuanPinjaman!)
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget agunanWidget(List<dynamic> data) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle2(
                text: 'Barang',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((val) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Subtitle2(
                      text: val['nama_jaminan'],
                      color: HexColor('#333333'),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle2(
                text: 'Berat/Karat',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((val) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Subtitle2(
                      text: '${val['gram']} gr/${val['karat']} k',
                      color: HexColor('#333333'),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle2(
                text: 'Jumlah',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((val) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Subtitle2(
                      text: val['jumlah_jaminan'].toString(),
                      color: HexColor('#333333'),
                    ),
                  );
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget totalPengembalian() {
    final detail = widget.dataDetail;
    if (detail != null && widget.namaProduk == 'Cicil Emas') {
      final List<dynamic> pengembalian = detail['pengembalianArray'] ?? [];
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Subtitle2Extra(
            text: 'Total Pengembalian',
          ),
          const SizedBox(height: 8),
          Subtitle3(
            text:
                'Total pengembalian dari jumlah dana pokok dan bunga yang didapatkan',
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 16),
          const Subtitle2Extra(
            text: 'Perhitungan Total Pengembalian',
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: SingleChildScrollView(
              child: Column(
                children: pengembalian.map((data) {
                  final key = 'Angsuran ${data['noUrut']}';
                  final denda = data['denda_keterlambatan'] ?? 0;
                  final total = data['angsuran'] + denda;
                  final val = rupiahFormat(total);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: keyVal7(key, val),
                  );
                }).toList(),
              ),
            ),
          ),
          dividerDashed(context),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle2(text: 'Total Pengembalian'),
              Subtitle2(
                text: rupiahFormat(widget.nilaiPengembalian),
                color: HexColor(lenderColor),
              )
            ],
          ),
        ],
      );
    }
    final Map<String, dynamic> pengembalian =
        detail!['detail_total_pengembalian'] ?? {};
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Subtitle2Extra(
          text: 'Total Pengembalian',
        ),
        const SizedBox(height: 8),
        Subtitle3(
          text:
              'Total pengembalian dari jumlah dana pokok dan bunga yang didapatkan',
          color: HexColor('#777777'),
        ),
        const SizedBox(height: 16),
        const Subtitle2Extra(
          text: 'Perhitungan Total Pengembalian',
        ),
        const SizedBox(height: 8),
        keyVal7(
          'Dana Pokok',
          rupiahFormat(widget.jumlahPendanaan),
        ),
        const SizedBox(height: 8),
        keyVal7(
          'Bunga',
          rupiahFormat(widget.nilaiPengembalian - widget.jumlahPendanaan),
        ),
        const SizedBox(height: 8),
        if ((widget.statusPendanaan == 'Terlambat' ||
                widget.statusPendanaan == 'Telat Bayar') &&
            pengembalian.containsKey('denda_keterlambatan'))
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: keyVal7(
              'Denda Keterlambatan',
              rupiahFormat(
                pengembalian['denda_keterlambatan'],
              ),
            ),
          ),
        dividerDashed(context),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Subtitle2(text: 'Total Pengembalian'),
            Subtitle2(
              text: rupiahFormat(widget.nilaiPengembalian),
              color: HexColor(lenderColor),
            )
          ],
        ),
      ],
    );
  }

  Widget potensiPengembalian() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Subtitle2Extra(
          text: 'Potensi Pengembalian',
        ),
        const SizedBox(height: 8),
        Subtitle3(
          text:
              'Akumulasi pengembalian dari jumlah dana pokok dan bunga yang akan didapatkan',
          color: HexColor('#777777'),
        ),
        const SizedBox(height: 16),
        const Subtitle2Extra(
          text: 'Perhitungan Pengembalian',
        ),
        const SizedBox(height: 8),
        keyVal7(
          'Dana Pokok',
          rupiahFormat(widget.danaPokok),
        ),
        const SizedBox(height: 8),
        keyVal7(
          'Bunga',
          rupiahFormat(widget.bungaRp),
        ),
        const SizedBox(height: 8),
        dividerDashed(context),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Subtitle2(text: 'Estimasi Pengembalian'),
            Subtitle2(
              text: rupiahFormat(widget.nilaiPengembalian),
              color: HexColor(lenderColor),
            )
          ],
        ),
      ],
    );
  }

  Widget pengembalianDijual() {
    //nominal  = penjualan
    //total kewajiban = dana_pokok
    final data = widget.dataDetail ?? {};
    final penjualan = data['penjualan'];
    final total = penjualan['bunga_lender_jual'] +
        penjualan['denda_lender_jual'] +
        penjualan['dana_pokok'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Subtitle2Extra(
          text: 'Total Pengembalians',
        ),
        const SizedBox(height: 8),
        Subtitle3(
          text:
              'Total pengembalian dari jumlah dana pokok dan bunga yang didapatkan',
          color: HexColor('#777777'),
        ),
        const SizedBox(height: 16),
        const Subtitle2Extra(
          text: 'Perhitungan Total Pengembalian',
        ),
        const SizedBox(height: 8),
        keyVal12500(
          'Penjualan Agunan',
          rupiahFormat(penjualan['nominal'] ?? 0),
        ),
        const SizedBox(height: 8),
        const Subtitle2(text: 'Biaya Pinjaman'),
        if (penjualan['biaya_penjualan'] != 0)
          Column(
            children: [
              const SizedBox(height: 8),
              keyVal7(
                'Biaya Penjualan',
                rupiahFormat(penjualan['biaya_penjualan'] ?? 0),
              ),
            ],
          ),
        const SizedBox(height: 8),
        keyVal7(
          'Biaya Jasa Mitra',
          rupiahFormat(penjualan['jasa_mitra_jual'] ?? 0),
        ),
        const SizedBox(height: 8),
        const Subtitle2(text: 'Pengembalian Pendanaan'),
        const SizedBox(height: 8),
        keyVal7(
          'Dana Pokok',
          rupiahFormat(penjualan['dana_pokok'] ?? 0),
        ),
        const SizedBox(height: 8),
        keyVal7(
          'Bunga',
          rupiahFormat(penjualan['bunga_lender_jual'] ?? 0),
        ),
        const SizedBox(height: 8),
        keyVal7(
          'Denda Keterlambatan',
          rupiahFormat(penjualan['denda_lender_jual'] ?? 0),
        ),
        dividerDashed(context),
        const SizedBox(height: 8),
        if (penjualan['bunga_lender_selisih'] < 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle2(text: 'Dana Pokok Tidak Terbayar'),
              Subtitle2(
                text: rupiahFormat(penjualan['bunga_lender_selisih'] * -1),
                color: HexColor('#EB5757'),
              )
            ],
          ),
        if (penjualan['bunga_lender_selisih'] >= 0 &&
            penjualan['kelebihan_penjualan'] > 0)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle2(text: 'Sisa Penjualan'),
                  Subtitle2(
                    text: rupiahFormat(penjualan['kelebihan_penjualan'] ?? 0),
                    color: HexColor('#27AE60'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.rotate(
                    angle: 3.14159265,
                    child: Icon(
                      Icons.error_outline,
                      color: HexColor('#F7951D'),
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Subtitle3(
                      text: 'Sisa penjualan akan dikembalikan ke peminjam',
                      color: HexColor('#AAAAAA'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        if (penjualan['bunga_lender_selisih'] == 0 &&
            penjualan['kelebihan_penjualan'] == 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle2(text: 'Total Pengembalian'),
              Subtitle2(
                text: rupiahFormat(total),
                color: HexColor('#27AE60'),
              )
            ],
          ),
      ],
    );
  }
}

class ItemPortfolio extends StatelessWidget {
  final String noSbg;
  final String image;
  final String status;
  final String namaProduk;
  final dynamic ratePendana;
  final int jumlahPendanaan;
  final String jatuhTemp;
  final String tanggalLunas;
  final int statusPendanaan;
  const ItemPortfolio({
    super.key,
    required this.noSbg,
    required this.image,
    required this.status,
    required this.namaProduk,
    required this.ratePendana,
    required this.jumlahPendanaan,
    required this.jatuhTemp,
    required this.tanggalLunas,
    required this.statusPendanaan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    image,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle2Extra(text: namaProduk),
                      const SizedBox(height: 4),
                      Subtitle4(
                        text: noSbg,
                        color: HexColor('#AAAAAA'),
                      )
                    ],
                  )
                ],
              ),
              checkStatus(statusPendanaan, status)
            ],
          ),
          const SizedBox(height: 8),
          dividerFullNoPadding(context),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Pendanaan',
                    color: HexColor('AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Subtitle2Extra(text: rupiahFormat(jumlahPendanaan))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Bunga',
                    color: HexColor('AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Subtitle2Extra(text: '${ratePendana}% p.a')
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: getTanggal(statusPendanaan),
                    color: HexColor('AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Subtitle2Extra(text: getTanggalResult(statusPendanaan))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget checkStatus(int status, String detailStatus) {
    if (status == 2) {
      return const SizedBox.shrink();
    } else {
      return statusBuilder(detailStatus);
    }
  }

  String getTanggal(int status) {
    if (statusPendanaan == 2) {
      return 'Tanggal Lunas';
    } else {
      return 'Jatuh Tempo';
    }
  }

  String getTanggalResult(int status) {
    if (status == 2) {
      return dateFormat(tanggalLunas);
    } else {
      return dateFormat(jatuhTemp);
    }
  }

  Widget statusBuilder(String status) {
    if (status == 'Aktif') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#F2F8FF'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Lancar',
          color: HexColor('#007AFF'),
        ),
      );
    }

    // if (status == 'Lunas') {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(18),
    //       color: HexColor('#F4FEF5'),
    //     ),
    //     alignment: Alignment.center,
    //     child: Subtitle3(
    //       text: 'Sudah Dibayar',
    //       color: HexColor('#28AF60'),
    //     ),
    //   );
    // }

    // if (status == 'Selesai') {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(18),
    //       color: HexColor('#F4FEF5'),
    //     ),
    //     alignment: Alignment.center,
    //     child: Subtitle3(
    //       text: 'Selesai',
    //       color: HexColor('#28AF60'),
    //     ),
    //   );
    // }

    if (status == 'Proses Pencairan') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#FFF4F4'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Proses Pencairan',
          color: HexColor('#EB5757'),
        ),
      );
    }

    if (status == 'Terlambat') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#FEF4E8'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: status,
          color: HexColor('#F7951D'),
        ),
      );
    }
    if (status == 'Gagal Bayar' || status == 'Pemutusan') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#FFF4F4'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Gagal Bayar',
          color: HexColor('#EB5757'),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
