import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/detail_portofolio_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/lender/portfolio_loading.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class StepDetailMaxi extends StatefulWidget {
  final DetailPortoBloc dpBloc;
  final String noSbg;
  const StepDetailMaxi({
    super.key,
    required this.dpBloc,
    required this.noSbg,
  });

  @override
  State<StepDetailMaxi> createState() => _StepDetailMaxiState();
}

class _StepDetailMaxiState extends State<StepDetailMaxi> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.dpBloc;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/images/icons/back.svg'),
        ),
        elevation: 0,
        title: Column(
          children: [
            const Headline2500(text: 'Detail Pendanaan'),
            const SizedBox(height: 8),
            Subtitle3(
              text: 'No. PP. ${widget.noSbg}',
              color: HexColor('#AAAAAA'),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.detailDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            print('data setimasi pendapatan ${data['estimasi_pendapatan']}');
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetDetailPortfolio(
                    image: data['url'],
                    jumlahPendanaan: data['nilai_pinjaman'] ?? 0,
                    nilaiPengembalian: data['estimasi_pendapatan'],
                    namaProduk: data['nama_produk'],
                    deskripsiProduk: data['deskripsi_produk'],
                    jatuhTempo: dateFormat(data['tanggal_jatuh_tempo']),
                    mulaiPendanaan: dateFormat(data['tgl_proses']),
                    terlambat:
                        data['terlambat'] != null && data['terlambat'] < 1
                            ? data['terlambat']
                            : null,
                    bungaRp: data['detail_total_pengembalian'] != null
                        ? data['detail_total_pengembalian']['bunga']
                        : 0,
                    danaPokok: data['detail_total_pengembalian'] != null
                        ? data['detail_total_pengembalian']['dana_pokok']
                        : 0,
                    bunga: data['rate_pendana'] ?? 0,
                    tenor: data['tenors'] ?? 0,
                    agunan: data['jaminan'],
                    mitra: data['nama_mitra'],
                    nama: data['nama'],
                    score: data['score'] ?? 0,
                    tujuanPinjaman: data['tujuan_pinjaman'],
                    statusPendanaan: data['status_pendanaan'],
                    dataDetail: data,
                    tanggalLunas: data['status_pendanaan'] == 'Lunas'
                        ? data['tgl_prepayment']
                        : null,
                  ),
                  dividerFull(context),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child:
                        Headline3500(text: 'Perjanjian Penyaluran Pendanaan'),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Button2(
                      btntext: 'Lihat Dokumen Perjanjian',
                      color: Colors.white,
                      textcolor: HexColor(lenderColor),
                      action: () {
                        bloc.stepChange(10);
                      },
                    ),
                  ),
                  dividerFull(context),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      bloc.stepChange(2);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Headline3500(text: 'Riwayat Pengembalian'),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: HexColor('#AAAAAA'),
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Subtitle2(text: snapshot.error.toString()),
            );
          }
          return const PortfolioLoading();
        },
      ),
    );
  }
}
