import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/component/home/home_component.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/auxpage/dokumen_perjanjian_pinjaman.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/component/angsuran_list.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/detail_transaksi_bloc.dart';
import 'package:flutter_danain/utils/string_format.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DetailTransaksi extends StatefulWidget {
  static const routeName = '/detail_transaction';
  final int idAgreement;

  const DetailTransaksi({
    super.key,
    this.idAgreement = 0,
  });

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    final bloc = context.bloc<DetailTransaksiBlocV3>();
    bloc.getRiwayatTransaksi(widget.idAgreement);
    // bloc.getDocumentPerjanjian();
  }

  @override
  void dispose() {
    context.bloc<DetailTransaksiBlocV3>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DetailTransaksiBlocV3>(context);

    return RefreshIndicator(
      onRefresh: () async {
        return bloc.getRiwayatTransaksi(widget.idAgreement);
      },
      child: StreamBuilder<Map<String, dynamic>?>(
        stream: bloc.response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final status = data['status'];
            return StreamBuilder<int>(
              stream: bloc.stepStream$,
              builder: (context, snapshot) {
                final step = snapshot.data ?? 1;
                return WillPopScope(
                  child: bodyBuilder(step, status, bloc),
                  onWillPop: () async {
                    if (step == 1) {
                      Navigator.pop(context);
                    } else {
                      bloc.stepChange(step - 1);
                    }
                    return false;
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: previousTitle(context, 'Detail Pinjaman'),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            return Scaffold(
              appBar: previousTitle(context, 'Detail Pinjaman'),
              body: const LoadingDanain(),
            );
          }
        },
      ),
    );
  }

  Widget bodyBuilder(
    int step,
    String statusTransaksi,
    DetailTransaksiBlocV3 bloc,
  ) {
    if (step == 1) {
      return step1Widget(context, bloc);
    } else if (step == 2) {
      return AngsuranListV3Page(
        transaksiBloc: bloc,
      );
    }
    return Container();
  }
}

Widget step1Widget(BuildContext context, DetailTransaksiBlocV3 bloc) {
  return Scaffold(
    appBar: AppBarWidget(
      context: context,
      isLeading: true,
      title: 'Detail Pinjaman',
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.response,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      TotalPinjaman(pinjamanData: snapshot.data!),
                      const SizedBox(height: 16),
                      DetailInformasi(pinjamanData: snapshot.data!),
                      const SizedBox(height: 16),
                      Agunan(pinjamanData: snapshot.data!),
                      const SizedBox(height: 16),
                      ProsesPencairan(pinjamanData: snapshot.data!),
                      const SizedBox(height: 16),
                      Angsuran(
                        pinjamanData: snapshot.data!,
                        transaksiBloc: bloc,
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class TotalPinjaman extends StatelessWidget {
  final Map<String, dynamic> pinjamanData;

  const TotalPinjaman({super.key, required this.pinjamanData});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DetailTransaksiBlocV3>(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: HexColor('#F9FFFA'),
        border: Border.all(width: 1, color: HexColor('#EEEEEE')),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 380,
                height: 180,
                color: pinjamanData['file'] != ''
                    ? Colors.transparent
                    : Colors.grey,
                child: pinjamanData['file'] != ''
                    ? Image.network(
                        pinjamanData['file'],
                        width: 380,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : null,
              )),
          const SizedBox(height: 16),
          Headline1(
            text: rupiahFormat(
              pinjamanData['pokokHutang'] ?? 0,
            ), // nilai pinjaman
            color: HexColor('#288C50'),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: dividerFullNoPadding(context),
          ),
          const SizedBox(height: 8),
          Subtitle500(text: pinjamanData['noPerjanjian']),
          const SizedBox(height: 4),
          StreamBuilder<dynamic>(
            stream: bloc.documentPerjanjian,
            builder: (context, snapshot) {
              print('check data perjanjina pp ${snapshot.data}');
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DokumenPerjanjianPinjaman.routeName,
                    arguments: snapshot.data.toString(),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Headline5(
                      text: 'Lihat Dokumen PP',
                      color: HexColor('#288C50'),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: HexColor('#288C50'),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailInformasi extends StatelessWidget {
  final Map<String, dynamic> pinjamanData;

  const DetailInformasi({
    super.key,
    required this.pinjamanData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: HexColor('#EEEEEE'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Headline3(text: 'Detail Informasi'),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 100,
                  child: detailData(
                      'Bunga Efektif', '${pinjamanData['rateEff']}% p.a')),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: detailData(
                  'Tenor',
                  '${pinjamanData['tenor']} Bulan',
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(width: 100, child: detailData('Tujuan', 'Produktif')),
            ],
          ),
          dividerFull2(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              detailData(
                'Nama Mitra Penyimpanan BPKB',
                pinjamanData['namaCabang'] ?? '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Agunan extends StatelessWidget {
  final Map<String, dynamic> pinjamanData;

  const Agunan({
    super.key,
    required this.pinjamanData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: HexColor('#EEEEEE'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Headline3(text: 'Agunan'),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: detailData('Jenis', pinjamanData['jenis']),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child:
                    detailData('Merek', shortText(pinjamanData['merek'], 10)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: detailData('Tipe', shortText(pinjamanData['tipe'], 10)),
              ),
            ],
          ),
          dividerFull2(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ModaLBottomTemplate(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SpacerV(value: 24),
                            const TextWidget(
                              text: 'Detail Agunan',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            const SpacerV(value: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  pinjamanData['jenis'] == 'Mobil'
                                      ? 'assets/images/icons/square_icCar.svg'
                                      : 'assets/images/icons/square_icMotor.svg',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                const SpacerH(value: 16),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text:
                                            '${pinjamanData['merek']} - ${pinjamanData['tipe']}',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      TextWidget(
                                        text: pinjamanData['model'],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: HexColor('#777777'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SpacerV(value: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KeyValVertical(
                                        title: 'Jenis Kendaraan',
                                        value: pinjamanData['jenis'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'Tahun Produksi',
                                        value: pinjamanData['tahunProduksi'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'CC Kendaraan',
                                        value: pinjamanData['ccKendaraan'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'Nomor Polisi',
                                        value: pinjamanData['noPolisi'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'Kondisi Kendaraan',
                                        value: pinjamanData['kondisiKendaraan'],
                                      ),
                                    ],
                                  ),
                                ),
                                const SpacerH(value: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KeyValVertical(
                                        title: 'Nomor STNK',
                                        value: pinjamanData['noStnk'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'Nomor Rangka',
                                        value: pinjamanData['noRangka'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'Nomor Mesin',
                                        value: pinjamanData['noMesin'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'Masa Berlaku',
                                        value: pinjamanData['masaBerlaku'],
                                      ),
                                      const SpacerV(value: 12),
                                      KeyValVertical(
                                        title: 'Nomor BPKB',
                                        value: pinjamanData['bpkb'],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Headline5(
                      text: 'Lihat Detail Agunan',
                      color: HexColor('#288C50'),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: HexColor('#288C50'),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProsesPencairan extends StatelessWidget {
  final Map<String, dynamic> pinjamanData;
  const ProsesPencairan({
    super.key,
    required this.pinjamanData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: HexColor('#EEEEEE'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Headline3(text: 'Proses Pencairan'),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              detailData('Waktu Pengajuan',
                  dateFormatTime(pinjamanData['tglPengajuan'])),
              detailData('Waktu Pencairan',
                  dateFormatTime(pinjamanData['tglPencairan'])),
              const SizedBox(width: 0),
            ],
          ),
        ],
      ),
    );
  }
}

class Angsuran extends StatelessWidget {
  final Map<String, dynamic> pinjamanData;
  final DetailTransaksiBlocV3 transaksiBloc;
  const Angsuran(
      {super.key, required this.pinjamanData, required this.transaksiBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: HexColor('#F9FFFA'),
          border: Border.all(width: 1, color: HexColor('#EEEEEE'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Headline3(text: 'Angsuran'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      transaksiBloc.stepChange(2);
                    },
                    child: Row(
                      children: [
                        Headline5(
                          text: 'Lihat Jadwal',
                          color: HexColor('#288C50'),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: HexColor('#288C50'),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: ShapeDecoration(
              color: pinjamanData['status'] == 'Aktif'
                  ? HexColor('#F2F8FF')
                  : HexColor('#FEF4E8'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Subtitle3(
                    text: "${pinjamanData['status']}",
                    color: pinjamanData['status'] == 'Aktif'
                        ? HexColor('#007AFF')
                        : HexColor('#F7951D')),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Subtitle500(
              text: '${rupiahFormat(pinjamanData['angsuranBulanan'])} / bulan'),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 70,
            animation: true,
            lineHeight: 8.0,
            barRadius: const Radius.circular(8),
            animationDuration: 2000,
            percent: pinjamanData['pembayaranKe'] / pinjamanData['tenor'],
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: HexColor('#007AFF'),
            backgroundColor: HexColor('#EDEDED'),
            padding: const EdgeInsets.only(right: 0),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Subtitle4(
                text: '${pinjamanData['pembayaranKe']} bulan',
                color: HexColor('#AAAAAA'),
              ),
              Subtitle4(
                text: 'dari ${pinjamanData['tenor']} bulan',
                color: HexColor('#AAAAAA'),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: HexColor('#FFF5F2'),
              border: Border.all(
                width: 1,
                color: HexColor('#FDE8CF'),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: 3.14159265,
                  child: Icon(
                    Icons.error_outline_outlined,
                    color: HexColor('#FF8829'),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Jatuh tempo berikutnya : ',
                          style: TextStyle(
                            color: HexColor('#777777'),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: dateFormatComplete(
                              pinjamanData['tglJt']), // jatuh tempo
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
