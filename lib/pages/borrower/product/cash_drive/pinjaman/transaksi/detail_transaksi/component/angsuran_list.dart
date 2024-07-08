import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/component/detail_transaksi_payment.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/detail_transaksi_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class AngsuranListV3Page extends StatefulWidget {
  final DetailTransaksiBlocV3 transaksiBloc;
  final int? isLunas;
  const AngsuranListV3Page({
    super.key,
    required this.transaksiBloc,
    this.isLunas,
  });

  @override
  State<AngsuranListV3Page> createState() => _AngsuranListV3PageState();
}

class _AngsuranListV3PageState extends State<AngsuranListV3Page> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.transaksiBloc;

    return Scaffold(
      appBar: previousTitleCustom(
        context,
        'Jadwal Pembayaran',
        () {
          if (widget.isLunas != null && widget.isLunas == 1) {
            Navigator.pop(context);
          } else {
            bloc.stepChange(1);
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              transaksiWidget(widget.transaksiBloc),
              const SizedBox(height: 16),
              const Headline2500(text: 'Pembayaran Angsuran'),
              const SizedBox(height: 16),
              StreamBuilder<Map<String, dynamic>?>(
                stream: bloc.response,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? {};
                    final List<dynamic> listAngsuran = data['paymentSchedule'];
                    return Column(
                      children: listAngsuran.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        final angsuranIndex = index + 1;
                        final num pokokHutang = item['pokokHutang'] ?? 0;
                        final num bunga = item['bunga'] ?? 0;
                        final num angsuran = item['angsuran'] +
                                item['denda'] +
                                item['cashback'] ??
                            0;
                        final bool isLast =
                            angsuranIndex == listAngsuran.length;
                        final num akhir = pokokHutang + angsuran;

                        return GestureDetector(
                          onTap: () {
                            if (item['statusPembayaran'] != 'Belum Bayar' &&
                                (item['status'] != 'Aktif' ||
                                    item['status'] != 'Proses Pencairan')) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return modalAngsuran(item, isLast, data);
                                },
                              );
                            }

                            if (item['status'] == 'Pemutusan' ||
                                item['status'] == 'Gagal Bayar') {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return modalAngsuran(item, isLast, data);
                                },
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: HexColor('#DDDDDD'),
                                    ),
                                    left: BorderSide(
                                      color: HexColor('#DDDDDD'),
                                    ),
                                    right: BorderSide(
                                      color: HexColor('#DDDDDD'),
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  color: item['statusPembayaran'] ==
                                              'Belum Bayar' &&
                                          item['status'] == 'Aktif'
                                      ? HexColor('#FAFAFA')
                                      : Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    keyValHeader(
                                      'Angsuran ke-${item['noUrut']}',
                                      rupiahFormat(isLast ? akhir : angsuran),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Subtitle2(
                                          text: dateFormat(item['tglJt']),
                                          color: HexColor('#777777'),
                                        ),
                                        statusBuilder(
                                            item, item['status'], data),
                                      ],
                                    ),
                                    // Adding the "Akumulasi Cashback" section
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  border: Border(
                                    left: BorderSide(
                                      width: 1,
                                      color: HexColor('#DDDDDD'),
                                    ),
                                    right: BorderSide(
                                      width: 1,
                                      color: HexColor('#DDDDDD'),
                                    ),
                                    bottom: BorderSide(
                                      width: 1,
                                      color: HexColor('#DDDDDD'),
                                    ),
                                  ),
                                  color: HexColor('#F5F9F6'),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/transaction/ic_cashback.svg',
                                          fit: BoxFit.fitWidth,
                                        ),
                                        const SizedBox(width: 4),
                                        Subtitle3(
                                          text: 'Potensi Cashback',
                                          color: HexColor('#777777'),
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                    ),
                                    TextWidget(
                                      text: rupiahFormat(
                                          item['potensialCashback']),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    // Adding the "Akumulasi Cashback" section
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const Subtitle1(
                    text: 'Maaf sepertinya tidak ada jadwal angsuran',
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget transaksiWidget(DetailTransaksiBlocV3 bloc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
                    'assets/images/transaction/background_cashback_pinjam.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(children: [
                      Subtitle2(
                        text: 'Akumulasi Cashback',
                        color: HexColor('#5F5F5F'),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.info,
                        color: HexColor('#8EB69B'),
                        size: 14,
                      ),
                    ]),
                    Subtitle16500(
                      text: rupiahFormat(0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget statusBuilder(Map<String, dynamic> dataAngsuran,
      String statusPembayaran, Map<String, dynamic> data) {
    final status = dataAngsuran['status'];
    if (statusPembayaran == 'Belum Dibayar') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#EEEEEE'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: statusPembayaran,
          color: HexColor('#777777'),
        ),
      );
    }
    if (statusPembayaran == 'Bayar Sekarang') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#F2F8FF'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Bayar Sekarang',
          color: HexColor('#007AFF'),
        ),
      );
    }

    if (statusPembayaran == 'Sudah Dibayar') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#F4FEF5'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: statusPembayaran,
          color: HexColor('#28AF60'),
        ),
      );
    }
    if (status == 'Telat Bayar') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#FEF4E8'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: statusPembayaran,
          color: HexColor('#F7951D'),
        ),
      );
    }
    if (statusPembayaran == 'Belum Bayar' &&
        (status == 'Gagal Bayar' || status == 'Pemutusan')) {
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

  Widget modalAngsuran(Map<String, dynamic> data, bool isLast,
      Map<String, dynamic> dataDetailRiwayat) {
    final num lastTotal =
        data['pokokHutang'] + data['bunga'] + data['mitra'] + data['denda'];
    final num Total = data['bunga'] + data['mitra'] + data['denda'];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              color: HexColor('#DDDDDD'),
            ),
          ),
          const SizedBox(height: 24),
          const Headline2500(text: 'Detail Pembayaran'),
          const SizedBox(height: 24),
          keyVal7('Periode', "Angsuran ke-${data['noUrut']}"),
          const SizedBox(height: 8),
          keyVal7('Jatuh Tempo', dateFormat(data['tglJt'])),
          const SizedBox(height: 8),
          if (isLast == true)
            Column(
              children: [
                keyVal7('Pokok Pinjaman', rupiahFormat(data['pokokHutang'])),
                const SizedBox(height: 8),
              ],
            ),
          if (data['status'] == 'Lunas')
            Column(
              children: [
                keyVal7('Tanggal Pembayaran', dateFormatTime(data['tglBayar'])),
                const SizedBox(height: 8),
              ],
            ),
          keyVal7('Bunga Pinjaman', rupiahFormat(data['bunga'])),
          // if (data['noUrut'] == 1)
          //   Column(
          //     children: [
          //       const SizedBox(height: 8),
          //       keyVal7(
          //         'Biaya Administrasi',
          //         rupiahFormat(data['biayaAdmin'] ?? 0),
          //       ),
          //     ],
          //   ),
          const SizedBox(height: 8),
          keyVal7(
            'Fee Jasa Mitra',
            rupiahFormat(data['mitra'] ?? 0),
          ),
          const SizedBox(height: 8),
          keyVal7(
            'Denda Keterlambatan',
            rupiahFormat(data['denda'] ?? 0),
          ),
          const SizedBox(height: 8),
          dividerDashed(context),
          const SizedBox(height: 8),
          keyVal3('Total Pembayaran',
              rupiahFormat(isLast == true ? lastTotal : Total)),
          const SizedBox(height: 16),
          Container(
            height: 50,
            color: Color(0xFFF5F9F6), // Background color set to #F5F9F6
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16), // Adjust the padding as needed
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/transaction/ic_cashback.svg',
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(width: 8), // Adjust spacing between icon and text
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Subtitle3(
                            text: 'Cashback ',
                            color: HexColor('#777777'),
                          ),
                          SizedBox(height: 2), // Adjust vertical spacing
                          TextWidget(
                            text: rupiahFormat(data['potensialCashback']),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          Subtitle3(
                            text: ' gagal diclaim',
                            color: HexColor('#777777'),
                          ),
                          // Adding the "Akumulasi Cashback" section
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          buttonStatus(data['status'], data, dataDetailRiwayat)
        ],
      ),
    );
  }

  Widget buttonStatus(String statusAngsuran, Map<String, dynamic> data,
      Map<String, dynamic> dataDetailRiwayat) {
    final pembayaranKe = dataDetailRiwayat['pembayaranKe'] + 1;
    if (pembayaranKe == data['noUrut'] &&
        (statusAngsuran == 'Aktif' ||
            statusAngsuran == 'Telat Bayar' ||
            statusAngsuran == 'Belum Dibayar')) {
      return Button1(
        btntext: "Bayar",
        action: () {
          // Call Navigator in the context of the current screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StepBayarDetailTransaksi(
                  transaksiBloc: widget.transaksiBloc, data: data),
            ),
          );
        },
      );
    } else if ((statusAngsuran == 'Lunas' ||
            statusAngsuran == 'Belum Dibayar' ||
            statusAngsuran == 'Gagal Bayar' ||
            statusAngsuran == 'Pemutusan') &&
        pembayaranKe != data['noUrut']) {
      return Button1(
        btntext: 'Tutup',
        action: () => Navigator.pop(context),
      );
    }

    return const SizedBox.shrink();
  }
}
