import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/detail_portofolio_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class StepPembayaran extends StatefulWidget {
  final DetailPortoBloc dpBloc;
  const StepPembayaran({
    super.key,
    required this.dpBloc,
  });

  @override
  State<StepPembayaran> createState() => _StepPembayaranState();
}

class _StepPembayaranState extends State<StepPembayaran> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.dpBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Riwayat Pengembalian', () {
        bloc.stepChange(1);
      }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: StreamBuilder<Map<String, dynamic>>(
          stream: bloc.detailDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              final List<dynamic> prosesList = data['proses_pengihan'] ?? [];
              final List<dynamic>? pengembalianArray =
                  data['pengembalianArray'];
              final Map<String, dynamic> pembayaran =
                  data['detail_total_pengembalian'];
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          LayoutBuilder(
                            builder: (context, BoxConstraints constraints) {
                              return SizedBox(
                                width: constraints.maxWidth,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SvgPicture.asset(
                                    'assets/images/transaction/background_transaksi.svg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Subtitle3(
                                      text: 'Total Pengembalian',
                                      color: HexColor('#777777'),
                                    ),
                                    const SizedBox(height: 8),
                                    Headline2500(
                                      text: rupiahFormat(
                                          pembayaran['total_pengembalian'] ??
                                              0),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Subtitle3(
                                      text: 'Pembayaran Diterima',
                                      color: HexColor('#777777'),
                                    ),
                                    const SizedBox(height: 8),
                                    Headline2500(
                                      text: rupiahFormat(
                                        pembayaran['pembayaran_diterima'] ?? 0,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (prosesList.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Button1Custom(
                            btntext: 'Lihat proses penagihan',
                            borderColor: HexColor('#F7951D'),
                            textcolor: HexColor('#F7951D'),
                            color: Colors.white,
                            action: () {
                              showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                builder: (context) {
                                  return prosesPenagihan(bloc);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    const Headline3500(text: 'Detail Pengembalian'),
                    const SizedBox(height: 24),
                    data['nama_produk'].toString().startsWith('C')
                        ? pengembalianArray != null
                            ? pengembalianArrayWidget(pengembalianArray)
                            : Container()
                        : detailPengembalian(data),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Subtitle2(text: snapshot.error.toString()),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget pengembalianArrayWidget(List<dynamic> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((item) {
        return detailCicilEmas(item);
      }).toList(),
    );
  }

  Widget detailPengembalian(
    Map<String, dynamic> data,
  ) {
    // final dataDetail = data['detail_total_pengembalian'];
    final detailTotalPengembalian = data['detail_total_pengembalian'];
    print('detail pengembalian $data');
    final totalPengembalian = detailTotalPengembalian != null
        ? detailTotalPengembalian['total_pengembalian']
        : 0;
    final colorBg = data['status_pendanaan'] == 'Lunas' ||
            data['status_pendanaan'] == 'Terlambat' ||
            data['status_pendanaan'] == 'Gagal Bayar'
        ? Colors.white
        : HexColor('#FAFAFA');
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: HexColor('#DDDDDD'),
        ),
        borderRadius: BorderRadius.circular(8),
        color: colorBg,
      ),
      child: Column(
        children: [
          keyValHeader(
            'Pembayaran',
            rupiahFormat(
              totalPengembalian ?? 0,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle2(
                text: dateFormat(data['tanggal_jatuh_tempo']),
                color: HexColor('#777777'),
              ),
              statusBuilder(data['status_pendanaan'])
            ],
          ),
        ],
      ),
    );
  }

  Widget detailCicilEmas(
    Map<String, dynamic> data,
  ) {
    print('data detail cicilan emas $data');
    final colorBg = data['status'] == 'Lunas' ||
            data['status'] == 'Terlambat' ||
            data['status'] == 'Gagal Bayar'
        ? Colors.white
        : HexColor('#FAFAFA');
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: HexColor('#DDDDDD'),
        ),
        borderRadius: BorderRadius.circular(8),
        color: colorBg,
      ),
      child: Column(
        children: [
          keyValHeader(
            data['keteranganKe'],
            rupiahFormat(
              data['angsuran'],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle2(
                text: dateFormat(
                  data['tglJt'] ?? DateTime.now().toString(),
                ),
                color: HexColor('#777777'),
              ),
              statusBuilder(data['status'])
            ],
          ),
        ],
      ),
    );
  }

  Widget statusBuilder(String status) {
    if (status == 'Aktif') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#EEEEEE'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Belum Dibayar',
          color: HexColor('#777777'),
        ),
      );
    }

    if (status == 'Lunas') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#F4FEF5'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Sudah Dibayar',
          color: HexColor('#28AF60'),
        ),
      );
    }
    if (status == 'Terlambat' || status == 'Telat Bayar') {
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
    if (status == 'Gagal Bayar') {
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

    if (status == 'Gagal Bayar') {
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

    if (status == 'Proses Pencairan') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#FFF4F4'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: status,
          color: HexColor('#EB5757'),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget prosesPenagihan(DetailPortoBloc bloc) {
    return Scaffold(
      appBar: previousTitle(context, 'Riwayat Penagihan'),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.detailDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final List<dynamic> proses = data['proses_pengihan'];
            if (proses.length < 1) {
              return const Center(
                child:
                    Subtitle1(text: 'Maaf tidak ada satupun proses penagihan'),
              );
            } else {
              return Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: proses.asMap().entries.map((entry) {
                      final index = entry.key;
                      final reversei = proses.length - index - 1;
                      final isLastElement = index == proses.length - 1;
                      return SizedBox(
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: isLastElement
                                        ? Colors.white
                                        : HexColor('#DDDDDD'),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Subtitle2(
                                      text: dateFormat(
                                          proses[reversei]['tanggal']),
                                      color: HexColor(lenderColor),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 1,
                                              color: Color(0xFFF0F0F0)),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x0C000000),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Subtitle2Extra(
                                            text: proses[reversei]
                                                ['keterangan'],
                                          ),
                                          const SizedBox(height: 8),
                                          Subtitle3(
                                            text: proses[reversei]['status'],
                                          ),
                                          const SizedBox(height: 8),
                                          if (proses[reversei]['bukti']
                                                  .toString() !=
                                              '')
                                            InkWell(
                                              onTap: () async {
                                                final url =
                                                    proses[reversei]['bukti'];
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                              child: Subtitle3(
                                                text: 'Lihat Bukti Penagihan',
                                                color: HexColor(lenderColor),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16)
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor(lenderColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          }

          if (snapshot.hasError) {
            return Center(
              child: Subtitle1(text: snapshot.error.toString()),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
