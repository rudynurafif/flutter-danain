import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class AngsuranListPage extends StatefulWidget {
  final CicilanDetailBloc cicilBloc;
  final int? isLunas;
  const AngsuranListPage({
    super.key,
    required this.cicilBloc,
    this.isLunas,
  });

  @override
  State<AngsuranListPage> createState() => _AngsuranListPageState();
}

class _AngsuranListPageState extends State<AngsuranListPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.cicilBloc;

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
              const Headline2500(text: 'Pembayaran Angsuran'),
              const SizedBox(height: 16),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.dataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? {};
                    final List<dynamic> listAngsuran = data['jadwalAngsuran'];
                    return Column(
                      children: listAngsuran.map((item) {
                        return GestureDetector(
                          onTap: () {
                            if (item['statusPembayaran'] != 'Belum Bayar' &&
                                (item['status'] != 'Aktif' ||
                                    item['status'] != 'Proses Pencairan')) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return modalAngsuran(item);
                                },
                              );
                            }

                            if (item['status'] == 'Pemutusan' ||
                                item['status'] == 'Gagal Bayar') {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return modalAngsuran(item);
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: HexColor('#DDDDDD'),
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  item['statusPembayaran'] == 'Belum Bayar' &&
                                          item['status'] == 'Aktif'
                                      ? HexColor('#FAFAFA')
                                      : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Column(
                                    children: [
                                      keyValHeader(
                                        item['keterangan'],
                                        rupiahFormat(item['nominal']),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Subtitle2(
                                            text: dateFormat(
                                              item['tanggalJatuhTempo'],
                                            ),
                                            color: HexColor('#777777'),
                                          ),
                                          statusBuilder(
                                            item['status'],
                                            item['statusPembayaran'],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
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

  Widget statusBuilder(String status, String statusPembayaran) {
    if (statusPembayaran == 'Belum Bayar' &&
        (status == 'Aktif' || status == 'Proses Pencairan')) {
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

  Widget modalAngsuran(Map<String, dynamic> data) {
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
          keyVal7('Periode', data['keterangan']),
          const SizedBox(height: 8),
          keyVal7('Jatuh Tempo', dateFormat(data['tanggalJatuhTempo'])),
          const SizedBox(height: 8),
          if (data['status'] == 'Lunas')
            Column(
              children: [
                keyVal7('Tanggal Pembayaran', dateFormatTime(data['tglBayar'])),
                const SizedBox(height: 8),
              ],
            ),
          keyVal7('Angsuran', rupiahFormat(data['angsuran'])),
          if (data['angsuranKe'] == 1)
            Column(
              children: [
                const SizedBox(height: 8),
                keyVal7(
                  'Biaya Administrasi',
                  rupiahFormat(data['biayaAdmin'] ?? 0),
                ),
              ],
            ),
          if (data['angsuranKe'] != 1)
            Column(
              children: [
                const SizedBox(height: 8),
                keyVal7(
                  'Fee Jasa Mitra',
                  rupiahFormat(data['feeJasaMitra'] ?? 0),
                ),
              ],
            ),
          if (data['angsuranKe'] != 1)
            Column(
              children: [
                const SizedBox(height: 8),
                keyVal7(
                  'Denda Keterlambatan',
                  rupiahFormat(data['denda'] ?? 0),
                ),
              ],
            ),
          const SizedBox(height: 8),
          dividerDashed(context),
          const SizedBox(height: 8),
          keyVal3('Total Pembayaran', rupiahFormat(data['nominal'])),
          const SizedBox(height: 24),
          buttonStatus(data['status'])
        ],
      ),
    );
  }

  Widget modalAngsuranPertama(Map<String, dynamic> data) {
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
          keyVal7('Periode', data['keterangan']),
          const SizedBox(height: 8),
          if (data['status'] == 'Lunas')
            Column(
              children: [
                keyVal7('Tanggal Pembayaran', dateFormatTime(data['tglBayar'])),
                const SizedBox(height: 8),
              ],
            ),
          keyVal7('Angsuran Pertama', rupiahFormat(data['angsuran'])),
          const SizedBox(height: 8),
          keyVal7('Biaya Administrasi', rupiahFormat(data['biayaAdmin'])),
          const SizedBox(height: 8),
          dividerDashed(context),
          const SizedBox(height: 8),
          keyVal3('Total Pembayaran', rupiahFormat(data['nominal'])),
          const SizedBox(height: 24),
          buttonStatus(data['status'])
        ],
      ),
    );
  }

  Widget buttonStatus(String statusAngsuran) {
    if (statusAngsuran == 'Aktif' || statusAngsuran == 'Telat Bayar') {
      return Button1(
        btntext: 'Bayar',
        action: () {
          widget.cicilBloc.getPayment();
          Navigator.pop(context);
        },
      );
    }

    if (statusAngsuran == 'Lunas' ||
        statusAngsuran == 'Gagal Bayar' ||
        statusAngsuran == 'Pemutusan') {
      return Button1(
        btntext: 'Tutup',
        action: () => Navigator.pop(context),
      );
    }

    return const SizedBox.shrink();
  }
}
