import 'package:flutter/material.dart';
import 'package:flutter_danain/component/lender/modal_component/modal_pendanaan.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan.dart';
import 'package:flutter_danain/widgets/lender/portfolio_loading.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class StepDetailPendanaan extends StatefulWidget {
  final PendanaanBloc pBloc;
  const StepDetailPendanaan({super.key, required this.pBloc});

  @override
  State<StepDetailPendanaan> createState() => _StepDetailPendanaanState();
}

class _StepDetailPendanaanState extends State<StepDetailPendanaan> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.pBloc;
    return StreamBuilder<Map<String, dynamic>?>(
      stream: bloc.detailDataPendanaan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  bloc.detailControl(false);
                  bloc.stepControl(1);
                },
                icon: SvgPicture.asset('assets/images/icons/back.svg'),
              ),
              elevation: 0,
              title: Column(
                children: [
                  const Headline2500(text: 'Detail Pendanaan'),
                  const SizedBox(height: 8),
                  Subtitle3(
                    text: 'No. PP. ${data['no_sbg']}',
                    color: HexColor('#AAAAAA'),
                  )
                ],
              ),
              centerTitle: true,
            ),
            body: bodyBuilder(data),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: previousTitleCustom(context, 'Detail Pendanaan', () {}),
            body: Center(
              child: Subtitle2(text: snapshot.error.toString()),
            ),
          );
        }

        return const PortfolioLoading();
      },
    );
  }

  Widget bodyBuilder(Map<String, dynamic> data) {
    print('check pembulatan step detail ${data['estimasi_pendapatan']}');
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetDetailPortfolio(
            image: data['url'],
            jumlahPendanaan: data['nilai_pinjaman'] ?? 0,
            nilaiPengembalian: data['estimasi_pendapatan'] ?? 0,
            namaProduk: data['nama_produk'] ?? 0,
            deskripsiProduk: data['deskripsi_produk'] ?? 0,
            bunga: data['rate_pendana'] ?? 0,
            tenor: data['tenors'] ?? 0,
            agunan: data['jaminan'] ?? [],
            mitra: data['nama_mitra'],
            nama: data['nama'],
            bungaRp: data['bungaMitraGadai'],
            danaPokok: data['nilai_pinjaman'],
            score: data['score'] ?? 0,
            tujuanPinjaman: data['nama_produk'].toString().startsWith('C')
                ? null
                : data['tujuan_pinjaman'],
          ),
          dividerFull(context),
          announcementPendanaan(context),
          const SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StreamBuilder<Map<String, dynamic>>(
                stream: widget.pBloc.dataBeranda,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final dataBeranda = snapshot.data ?? {};
                    return Button1(
                      btntext: 'Danain',
                      color: HexColor(lenderColor),
                      action: () {
                        if (dataBeranda['Aktivasi'] == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => notVerifPopUp(context),
                          );
                        }
                        if (dataBeranda['Aktivasi'] == 9) {
                          showDialog(
                            context: context,
                            builder: (context) => waitingVerifPopUp(context),
                          );
                        }
                        if (dataBeranda['Aktivasi'] == 11 ||
                            dataBeranda['Aktivasi'] == 12) {
                          showDialog(
                            context: context,
                            builder: (context) => rejectVerifPopUp(context),
                          );
                        }

                        if (dataBeranda['Aktivasi'] == 1) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => ModalConfirmPendanaan(
                              bloc: widget.pBloc,
                            ),
                          );
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class ModalConfirmPendanaan extends StatelessWidget {
  final PendanaanBloc bloc;
  const ModalConfirmPendanaan({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: StreamBuilder<Map<String, dynamic>?>(
        stream: bloc.detailDataPendanaan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            print('estimasi: ${data['estimasi_pendapatan']}');
            String getTenor() {
              if (data['nama_produk'].toString().startsWith('C')) {
                return 'bulan';
              } else {
                return 'hari';
              }
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Container(
                  width: 42,
                  height: 4,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFDDDDDD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Headline1(text: 'Konfirmasi Pendanaan'),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          data['nama_produk'].toString().startsWith('C')
                              ? 'assets/lender/pendanaan/cicil_emas_logo.svg'
                              : 'assets/lender/pendanaan/maxi_logo.svg',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Headline3500(text: data['nama_produk']),
                            const SizedBox(height: 4),
                            Subtitle2(text: 'No. PP ${data['no_sbg']}')
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 33),
                    keyVal(
                      'Jumlah Pendanaan',
                      rupiahFormat(data['nilai_pinjaman']),
                    ),
                    const SizedBox(height: 8),
                    keyVal('Bunga Pendanaan', '${data['rate_pendana']}%'),
                    const SizedBox(height: 8),
                    keyVal('Tenor', '${data['tenors']} ${getTenor()}'),
                    const SizedBox(height: 8),
                    keyVal(
                        'Skema Bayar',
                        data['nama_produk'].toString().startsWith('C')
                            ? 'Angsuran'
                            : 'Sekali Bayar'),
                    const SizedBox(height: 8),
                    dividerDashed(context),
                    const SizedBox(height: 8),
                    keyVal(
                      'Potensi Pengembalian',
                      rupiahFormatNum(
                        data['estimasi_pendapatan'],
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Button1(
                      btntext: 'Danain',
                      color: HexColor(lenderColor),
                      action: () {
                        bloc.checkSaldoFunction(data['nilai_pinjaman']);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Image.asset('assets/lender/loading/danain.png'),
            );
          }
        },
      ),
    );
  }
}
