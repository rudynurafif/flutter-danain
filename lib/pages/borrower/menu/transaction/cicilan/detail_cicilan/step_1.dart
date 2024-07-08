import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_page.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_index.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/step2/angsuran_list.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/divider/divider.dart';
import 'package:flutter_danain/widgets/form/keyVal.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_danain/widgets/rupiah_format.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'detail_cicilan_loading.dart';

class Step1DetailCicilan extends StatefulWidget {
  final CicilanDetailBloc detailBloc;
  const Step1DetailCicilan({super.key, required this.detailBloc});

  @override
  State<Step1DetailCicilan> createState() => _Step1DetailCicilanState();
}

class _Step1DetailCicilanState extends State<Step1DetailCicilan> {
  bool expandEmas = true;

  bool haveRatingToko = false;

  bool expandeAngsuranPertama = true;
  void showTotalPembayaranModal() {
    showDialog(
      context: context,
      builder: (context) => ModalDetailAngsuran(
          content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Detail Total Pembayaran'),
          const SizedBox(height: 16),
          keyVal('Harga Perolehan Emas', rupiahFormat(4800000)),
          const SizedBox(height: 8),
          keyVal('Bunga', rupiahFormat(20000)),
          const SizedBox(height: 8),
          keyVal('Biaya Administrasi', rupiahFormat(20000)),
          const SizedBox(height: 8),
          dividerDashed(context),
          const SizedBox(height: 8),
          keyValHeader2('Total Pembayaran', rupiahFormat(482000)),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.detailBloc;
    return Scaffold(
      appBar: previousTitle(context, 'Detail Cicil Emas'),
      body: SingleChildScrollView(
        child: StreamBuilder<Map<String, dynamic>>(
          stream: bloc.dataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data ?? {};
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(data),
                  detailTransaksi(data),
                  dividerFull(context),
                  mitraEmas(data),
                  dividerFull(context),
                  detailEmas(),
                  listEmas(data),
                  dividerFull(context),
                  footerDetail(data),
                  const SizedBox(height: 16),
                ],
              );
            }
            return const DetailCicilanLoading();
          },
        ),
      ),
    );
  }

  Widget header(Map<String, dynamic> data) {
    if (data['status'] == 'Pending') {
      final Map<String, dynamic> expired = data['pembayaranPending'];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(24),
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
            Icon(
              Icons.credit_card,
              color: HexColor('#FF8829'),
              size: 16,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Headline5(text: 'Menunggu Pembayaran'),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'Segera selesaikan pembayaran biaya awal sebelum ',
                          style: TextStyle(
                            color: HexColor('777777'),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: formatDateFull(expired['expiredPayment']),
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
                ],
              ),
            )
          ],
        ),
      );
    }

    if (data['status'] == 'Lunas') {
      final Map<String, dynamic> pelunasan = data['dataPelunasan'];
      if (pelunasan.containsKey('QRPelunasan')) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.all(24),
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
              SvgPicture.asset(
                  'assets/lender/portofolio/terlambat_cicil_emas.svg'),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Headline5(text: 'Yuk, Segera Ambil Emas!'),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Segera ambil emas Anda sebelum ',
                            style: TextStyle(
                              color: HexColor('777777'),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '${dateFormat(pelunasan['TanggalAmbil'])} ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ModalDetailAngsuran(
                                    content: Text.rich(
                                      TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                'Jika Anda mengambil emas melebihi ',
                                            style: TextStyle(
                                              color: HexColor('777777'),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: dateFormat(
                                                pelunasan['TanggalAmbil']),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' maka akan dikenakan biaya simpan emas.',
                                            style: TextStyle(
                                              color: HexColor('777777'),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Transform.rotate(
                                  angle: 3.14159265,
                                  child: const Icon(
                                    Icons.error_outline,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    }
    if (data['status'] == 'Pemutusan') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: HexColor('#FDEEEE'),
          border: Border.all(
            width: 1,
            color: HexColor('#FBDDDD'),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
                'assets/lender/portofolio/pembatalan_cicil_emas.svg'),
            const SizedBox(width: 8),
            Flexible(
              child: Subtitle2(
                text:
                    'Dalam situasi pemutusan emas akan dijual dan jika hasil penjualan lebih dari kewajiban, sisa dana akan dikembalikan kepada Anda.',
                color: HexColor('#5F5F5F'),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox(height: 24);
  }

  Widget invoice(String? documentUrl, data) {
    if (documentUrl!.isNotEmpty) {
      return Scaffold(
        appBar: previousTitle(context, data),
        body: PDF(
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
        ).fromUrl(
          documentUrl,
        ),
      );
    }

    return Scaffold(
      appBar: previousTitle(context, data),
      body: const Center(
        child: Subtitle2(text: 'Maaf dokumen tidak tersedia'),
      ),
    );
  }

  Widget detailTransaksi(Map<String, dynamic> data) {
    final Map<String, dynamic> dataTotal = data['totalPembayaran'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Detail Transaksi Cicil Emas'),
          const SizedBox(height: 8),
          keyVal7('ID Transaksi', data['idTransaksi'] ?? ''),
          const SizedBox(height: 8),
          if (data['status'] == 'Lunas')
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Subtitle2(
                      text: 'Invoice Transaksi',
                      color: HexColor('#777777'),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) => invoice(
                              data['dataPelunasan']['FilePelunasan'],
                              data['idTransaksi']),
                        );
                      },
                      child: Subtitle2Extra(
                        text: 'Lihat Invoice',
                        color: HexColor('#288c50'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          keyVal7(
            'Tanggal Pengajuan',
            dateFormat(
              data['tanggal'] ?? DateTime.now().toString(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Subtitle2(
                    text: 'Total Pembayaran',
                    color: HexColor('#777777'),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final dataTotal = data['totalPembayaran'];
                          return ModalDetailAngsuran(
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Headline3500(text: 'Detail Total Pembayaran'),
                                const SizedBox(height: 16),
                                keyVal7('Harga Perolehan Emas',
                                    rupiahFormat(dataTotal['hargaEmas'])),
                                const SizedBox(height: 8),
                                keyVal7(
                                    'Bunga', rupiahFormat(dataTotal['bunga'])),
                                const SizedBox(height: 8),
                                keyVal7('Biaya Administrasi',
                                    rupiahFormat(dataTotal['biayaAdmin'])),
                                const SizedBox(height: 8),
                                keyVal7('Fee Jasa Mitra',
                                    rupiahFormat(dataTotal['jasaMitra'])),
                                const SizedBox(height: 8),
                                dividerDashed(context),
                                const SizedBox(height: 8),
                                keyValHeader2('Total Pembayaran',
                                    rupiahFormat(dataTotal['total'])),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Transform.rotate(
                      angle: 3.14159265,
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 14,
                      ),
                    ),
                  )
                ],
              ),
              Subtitle2(
                text: rupiahFormat(dataTotal['total'] ?? 0),
              )
            ],
          ),
          const SizedBox(height: 8),
          keyVal7('Jangka Waktu Angsuran', '${data['tenor']} Bulan'),
          const SizedBox(height: 8),
          keyVal7(
            'Angsuran Bulanan',
            rupiahFormat(data['angsuran'] ?? 0),
          )
        ],
      ),
    );
  }

  Widget detailEmas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            expandEmas = !expandEmas;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Headline3500(text: 'Detail Emas'),
            Icon(
              expandEmas ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget listEmas(Map<String, dynamic> data) {
    final List<dynamic> listEmas = data['detailEmas'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Visibility(
        visible: expandEmas,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      data['imgSupplier'],
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset(
                          'assets/images/simulasi/lotus.svg',
                          width: 18,
                          height: 18,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Subtitle1(text: data['namaSupplier'] ?? '')
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      TokoEmasIndex.routeName,
                      arguments: TokoEmasIndex(
                        idSupplier: data['idSupplier'],
                      ),
                    );
                  },
                  child: Headline5(
                    text: 'Detail Toko >',
                    color: HexColor('#288C50'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: listEmas.asMap().entries.map(
                (entry) {
                  final Map<String, dynamic> e = entry.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: HexColor('#EEEEEE'),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          e['imgJenisEmas'],
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                              'assets/images/simulasi/lotus.svg',
                              width: 32,
                              height: 32,
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Subtitle2Extra(
                                text: '${e['namaEmas']} - ${e['berat']} gram'),
                            const SizedBox(height: 4),
                            Headline5(
                              text:
                                  '${e['jumlah']} x ${rupiahFormat(e['harga'])}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
            dividerDashed(context),
            const SizedBox(height: 16),
            keyValExtra(
              'Harga Perolehan Emas',
              rupiahFormat(data['harga']),
            )
          ],
        ),
      ),
    );
  }

  Widget footerDetail(Map<String, dynamic> data) {
    final status = data['status'];
    if (status == 'Pending') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  expandeAngsuranPertama = !expandeAngsuranPertama;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Headline3500(text: 'Detail Angsuran Pertama'),
                  Icon(
                    expandeAngsuranPertama
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.grey,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          detailAngsuranPertama(data['pembayaranPending']),
          dividerFull(context),
          statusBelumBayar(data)
        ],
      );
    }

    if (status == 'Aktif') {
      return statusAktif(data);
    }

    if (status == 'Telat Bayar') {
      return statusTelat(data);
    }

    if (status == 'Lunas') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          statusSelesai(data),
          dividerFull(context),
          giveResponseButton(data)
        ],
      );
    }

    if (status == 'Gagal Bayar') {
      return Column(
        children: [
          statusGagal(data),
          dividerFull(context),
          detailBiayaKembali(data)
        ],
      );
    }
    if (status == 'Pemutusan') {
      return Column(
        children: [
          statusPemutusan(data),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget giveResponseButton(Map<String, dynamic> data) {
    final Map<String, dynamic> dataSelesai = data['dataPelunasan'];
    if (dataSelesai.containsKey('QRPelunasan')) {
      return Container(
        padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
        child: Button1(
          btntext: 'Ambil Emas Sekarang',
          action: () {
            widget.detailBloc.stepChange(2);
          },
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
      child: Button1(
        btntext: 'Nyicil Lagi',
        action: () {
          Navigator.pushNamed(
            context,
            CicilEmas2Page.routeName,
          );
        },
      ),
    );
  }

  Widget statusBelumBayar(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          StreamBuilder<bool>(
            stream: widget.detailBloc.isLoadingButton$,
            builder: (context, snapshot) {
              final isLoading = snapshot.data ?? false;
              if (isLoading == true) {
                return const ButtonLoading();
              }
              return Button1(
                btntext: 'Bayar',
                action: () {
                  // widget.detailBloc.isLoadingButtonChange(true);
                  // widget.detailBloc.reqOtp();
                  widget.detailBloc.stepChange(2);
                },
              );
            },
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ModalPopUp(
                    icon: 'assets/images/icons/warning_red.svg',
                    title: 'Batalkan Transaksi',
                    message:
                        'Apakah Anda yakin ingin membatalkan pengajuan cicil emas ini?',
                    actions: [
                      Button2(
                        btntext: 'Tidak',
                        action: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 11),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            widget.detailBloc.batalkanTransaksi();
                            context.showSnackBarSuccess('Mohon tunggu...');
                          },
                          child: Headline5(
                            text: 'Ya, Batalkan',
                            align: TextAlign.center,
                            color: HexColor(primaryColorHex),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Headline3(
                text: 'Batalkan Transaksi',
                color: HexColor('#EB5757'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget detailAngsuranPertama(Map<String, dynamic> data) {
    return Visibility(
      visible: expandeAngsuranPertama,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            keyVal('Angsuran Pertama', rupiahFormat(data['angsuranPertama'])),
            const SizedBox(height: 8),
            keyVal('Biaya Administrasi', rupiahFormat(data['biayaAdmin'])),
            const SizedBox(height: 8),
            dividerDashed(context),
            const SizedBox(height: 8),
            keyVal(
              'Total Angsuran Pertama',
              rupiahFormat(data['totalPembayaran']),
            )
          ],
        ),
      ),
    );
  }

  Widget statusAktif(Map<String, dynamic> data) {
    final List<dynamic> paymentSchedule = data['jadwalAngsuran'];
    final List<dynamic> lunasList = paymentSchedule.where((schedule) {
      return schedule['status'] == 'Lunas';
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Headline3500(text: 'Angsuran'),
              InkWell(
                onTap: () {
                  widget.detailBloc.stepChange(2);
                },
                child: Headline5(
                  text: 'Lihat Jadwal >',
                  color: HexColor('#288C50'),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: HexColor('#F2F8FF'),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: HexColor('#E8F2FF'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Subtitle3(
                    text: 'Aktif',
                    color: HexColor('#007AFF'),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Headline3500(
                      text: '${rupiahFormat(data['angsuran'])} / bulan'),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 70,
                    animation: true,
                    lineHeight: 8.0,
                    barRadius: const Radius.circular(8),
                    animationDuration: 2000,
                    percent: lunasList.length / data['tenor'],
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: HexColor('#007AFF'),
                    backgroundColor: HexColor('#EDEDED'),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Subtitle4(
                        text: '${lunasList.length} bulan',
                        color: HexColor('#AAAAAA'),
                      ),
                      Subtitle4(
                        text: 'dari ${data['tenor']} bulan',
                        color: HexColor('#AAAAAA'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          keyVal(
            'Jatuh Tempo Selanjutnya',
            dateFormat(data['tglJatuhTempoAngsuranNext']),
          )
        ],
      ),
    );
  }

  Widget statusTelat(Map<String, dynamic> dataList) {
    final List<dynamic> paymentSchedule = dataList['jadwalAngsuran'];
    final List<dynamic> lunasList = paymentSchedule.where((schedule) {
      return schedule['status'] == 'Lunas';
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Headline3500(text: 'Angsuran'),
              InkWell(
                onTap: () {
                  widget.detailBloc.stepChange(2);
                },
                child: Headline5(
                  text: 'Lihat Jadwal >',
                  color: HexColor('#288C50'),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: HexColor('#FEF4E8'),
              border: Border.all(
                width: 1,
                color: HexColor('#FDE8CF'),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Subtitle3(
                    text: 'Telat Bayar',
                    color: HexColor('#F7951D'),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Headline3500(
                      text: '${rupiahFormat(dataList['angsuran'])} / bulan'),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 70,
                    animation: true,
                    lineHeight: 8.0,
                    barRadius: const Radius.circular(8),
                    animationDuration: 2000,
                    percent: lunasList.length / dataList['tenor'],
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: HexColor('#F7951D'),
                    backgroundColor: HexColor('#EDEDED'),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Subtitle4(
                        text: '${lunasList.length} bulan',
                        color: HexColor('#AAAAAA'),
                      ),
                      Subtitle4(
                        text: 'dari ${dataList['tenor']} bulan',
                        color: HexColor('#AAAAAA'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          keyVal(
            'Jatuh Tempo Selanjutnya',
            dateFormat(dataList['tglJatuhTempoAngsuranNext']),
          )
        ],
      ),
    );
  }

  Widget detailBiayaKembali(Map<String, dynamic> dataBiayaKembali) {
    final dataBiayaKembalis = dataBiayaKembali['dataPenjualan'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Detail Biaya Pengembalian'),
          const SizedBox(height: 16),
          keyVal12500('Penjualan Emas',
              rupiahFormat(dataBiayaKembalis['penjualan_emas'])),
          const SizedBox(height: 8),
          keyVal12500('Angsuran Terbayar',
              rupiahFormat(dataBiayaKembalis['angsuranTerbayar'])),
          const SizedBox(height: 8),
          const Subtitle2Extra(text: 'Tagihan'),
          const SizedBox(height: 8),
          keyVal7('Total Kewajiban',
              rupiahFormat(dataBiayaKembalis['totalKewajiban'])),
          const SizedBox(height: 8),
          keyVal7('Biaya Penjualan',
              rupiahFormat(dataBiayaKembalis['biayaPenjualan'])),
          const SizedBox(height: 8),
          keyVal7(
              'Denda Keterlambatan', rupiahFormat(dataBiayaKembalis['denda'])),
          const SizedBox(height: 8),
          dividerDashed(context),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Subtitle2Extra(text: 'Total Pengembalian Dana'),
              Subtitle2Extra(
                text: rupiahFormat(dataBiayaKembalis['totalPengembalianDana']),
                color: HexColor('#27AE60'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: HexColor('#FDEEEE'),
              border: Border.all(
                width: 1,
                color: HexColor('#FBDDDD'),
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
                          text:
                              'Pengembalian dana ditransfer ke rekening terdaftar Anda pada Maksimal',
                          style: TextStyle(
                            color: HexColor('#777777'),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: ' 7 hari kerja',
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

  Widget statusGagal(Map<String, dynamic> data) {
    final List<dynamic> paymentSchedule = data['jadwalAngsuran'];
    final List<dynamic> lunasList = paymentSchedule.where((schedule) {
      return schedule['status'] == 'Lunas';
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Headline3500(text: 'Angsuran'),
              InkWell(
                onTap: () {
                  widget.detailBloc.stepChange(2);
                },
                child: Headline5(
                  text: 'Lihat Jadwal >',
                  color: HexColor('#288C50'),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: HexColor('#FDEEEE'),
              border: Border.all(
                width: 1,
                color: HexColor('#FDEEEE'),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Subtitle3(
                    text: 'Gagal Bayar',
                    color: HexColor('#EB5757'),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Headline3500(
                    text: '${rupiahFormat(data['angsuran'])} / bulan',
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 70,
                    animation: true,
                    lineHeight: 8.0,
                    barRadius: const Radius.circular(8),
                    animationDuration: 2000,
                    percent: lunasList.length / data['tenor'],
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: HexColor('#EB5757'),
                    backgroundColor: HexColor('#EDEDED'),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Subtitle4(
                        text: '${lunasList.length} bulan',
                        color: HexColor('#AAAAAA'),
                      ),
                      Subtitle4(
                        text: 'dari ${data['tenor']} bulan',
                        color: HexColor('#AAAAAA'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statusPemutusan(Map<String, dynamic> data) {
    final List<dynamic> paymentSchedule = data['jadwalAngsuran'];
    final List<dynamic> lunasList = paymentSchedule.where((schedule) {
      return schedule['status'] == 'Lunas';
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Headline3500(text: 'Angsuran'),
              InkWell(
                onTap: () {
                  widget.detailBloc.stepChange(2);
                },
                child: Headline5(
                  text: 'Lihat Jadwal >',
                  color: HexColor('#288C50'),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: HexColor('#FDEEEE'),
              border: Border.all(
                width: 1,
                color: HexColor('#FDEEEE'),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Subtitle3(
                    text: 'Pemutusan',
                    color: HexColor('#EB5757'),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Headline3500(
                    text: '${rupiahFormat(data['angsuran'])} / bulan',
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 70,
                    animation: true,
                    lineHeight: 8.0,
                    barRadius: const Radius.circular(8),
                    animationDuration: 2000,
                    percent: lunasList.length / data['tenor'],
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: HexColor('#EB5757'),
                    backgroundColor: HexColor('#EDEDED'),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Subtitle4(
                        text: '${lunasList.length} bulan',
                        color: HexColor('#AAAAAA'),
                      ),
                      Subtitle4(
                        text: 'dari ${data['tenor']} bulan',
                        color: HexColor('#AAAAAA'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statusSelesai(Map<String, dynamic> data) {
    final List<dynamic> paymentSchedule = data['jadwalAngsuran'];
    final List<dynamic> lunasList = paymentSchedule.where((schedule) {
      return schedule['status'] == 'Lunas';
    }).toList();
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Headline3500(text: 'Angsuran'),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) {
                      return AngsuranListPage(
                        cicilBloc: widget.detailBloc,
                        isLunas: 1,
                      );
                    },
                  );
                },
                child: Headline5(
                  text: 'Lihat Jadwal >',
                  color: HexColor('#288C50'),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: HexColor('#E8F7EE'),
              border: Border.all(
                width: 1,
                color: HexColor('#E8F7EE'),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Subtitle3(
                    text: 'Selesai',
                    color: HexColor('#28AF60'),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Headline3500(
                    text: '${rupiahFormat(data['angsuran'])} / bulan',
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 70,
                    animation: true,
                    lineHeight: 8.0,
                    barRadius: const Radius.circular(8),
                    animationDuration: 2000,
                    percent: lunasList.length / data['tenor'],
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: HexColor('#28AF60'),
                    backgroundColor: HexColor('#EDEDED'),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Subtitle4(
                        text: '${lunasList.length} bulan',
                        color: HexColor('#AAAAAA'),
                      ),
                      Subtitle4(
                        text: 'dari ${data['tenor']} bulan',
                        color: HexColor('#AAAAAA'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget mitraEmas(Map<String, dynamic> data) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Lokasi Mitra Pengambilan Emas'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/icons/mitra.svg'),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleExtra(text: data['mitraPengambilan']),
                  const SizedBox(height: 4),
                  Subtitle2(
                    text: data['alamatMitraPengambilan'],
                    color: HexColor('#777777'),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}
