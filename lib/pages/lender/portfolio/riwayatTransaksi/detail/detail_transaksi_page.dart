import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/components/new_pendanaan.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/portofolio_detail_page.dart';
import 'package:flutter_danain/pages/lender/portfolio/riwayatTransaksi/detail/detail_transaksi_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailTransaksiPage extends StatefulWidget {
  static const routeName = '/detail_transaksi_lender';
  final Map<String, dynamic>? dataTransaksi;
  const DetailTransaksiPage({
    super.key,
    this.dataTransaksi,
  });

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  @override
  void initState() {
    super.initState();
    context.bloc<DetailTransaksiBloc>().getDataDetailTransaksi();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<DetailTransaksiBloc>();

    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          print('datanya: $data');
          Widget statusWidget = Subtitle2(
            text: 'Dalam Proses',
            color: HexColor('#F7951D'),
          );

          final String statusWd = data['status'];
          final bool isNotValid = statusWd == 'Dalam Proses' && data['kdTrans'] == 'WTH';
          final bool isNotValidRupiah = (statusWd == '' && data['kdTrans'] == 'WTH') ||
              data['keterangan'] == 'Tarik Dana' ||
              (data['kdTrans'] == 'PNP' || data['kdTrans'] == 'PPH23');
          if (!isNotValid) {
            statusWidget = Subtitle2(
              text: 'Berhasil',
              color: HexColor(lenderColor),
            );
          }
          if (data['keterangan'] == 'Refund Pendanaan') {
            return refundPendanaan(data);
          } else {
            return Scaffold(
              appBar: previousTitle(context, 'Detail Transaksi'),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              isNotValid
                                  ? 'assets/lender/pendanaan/pending.svg'
                                  : 'assets/lender/pendanaan/check.svg',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 16),
                            Subtitle2(
                              align: TextAlign.center,
                              text: data['keterangan'],
                              color: HexColor('#777777'),
                            ),
                            const SizedBox(height: 8),
                            Headline1500(
                              align: TextAlign.center,
                              text: rupiahFormat(data['amount'] ?? 0),
                              color: isNotValidRupiah ? HexColor('#EB5757') : HexColor('#28AF60'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      produkWidget(data),
                      const Headline3500(text: 'Detail Transaksi'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Subtitle2(
                            text: 'Status',
                            color: HexColor('#777777'),
                          ),
                          statusWidget,
                        ],
                      ),
                      if (data['kdTrans'] == 'DEP' || data['kdTrans'] == 'WTH')
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            keyVal7('No. Referensi', data['refNo']),
                          ],
                        ),
                      const SizedBox(height: 8),
                      keyVal7('Jenis Transaksi', data['keterangan']),
                      if (data['kdTrans'] == 'PBL' || data['kdTrans'] == 'PRP')
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            keyVal7('Periode', 'Angsuran ke-${data['periode']}')
                          ],
                        ),
                      dividerFull2(context),
                      (data['kdTrans'] == 'DEP' ||
                              data['kdTrans'] == 'PBL' ||
                              data['kdTrans'] == 'PRP' ||
                              data['kdTrans'] == 'PNP')
                          ? keyVal7(
                              'Waktu',
                              dateTimeModified(data['tanggal']),
                            )
                          : keyVal7(
                              'Waktu Pengajuan',
                              dateTimeModified(data['tanggal']),
                            ),
                      if (data['kdTrans'] == 'WTH' && data['status'] == 'Berhasil')
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            keyVal7(
                              'Waktu Pencairan',
                              dateTimeModified(data['tanggal_cair']),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return const LoadingDanain();
      },
    );
  }

  Widget refundPendanaan(Map<String, dynamic> data) {
    return Scaffold(
      appBar: previousTitle(context, 'Detail Pendanaan'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Transaksi Tidak Berhasil',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: HexColor('#EFEFEF'),
                ),
                child: Expanded(
                  child: TextWidget(
                    text:
                        'Mohon maaf produk pendanaan yang di pilih sedang tidak tersedia. Dana pembayaran telah dikembalikan ke saldo tersedia.',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#5F5F5F'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const TextWidget(
                text: 'Detail Produk',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              PendanaanStatus(
                idPendanaan: data['idPendanaan'],
                namaProduk: data['namaProduk'],
                picture: data['picture'],
                noPerjanjianPinjaman: data['noPerjanjianPinjaman'],
                jumlahPendanaan: data['jumlahPendanaan'],
                bunga: data['bunga'],
                date: data['tglJT'],
              ),
              const SizedBox(height: 8),
              const TextWidget(
                text: 'Rincian Transaksi',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              keyVal8('Status', data['status']),
              const SizedBox(height: 8),
              keyVal7(
                'Waktu',
                dateTimeModified(data['tgl_transaksi']),
              ),
              const SizedBox(height: 8),
              keyVal7('Jenis Transaksi', data['jenis_transaksi']),
              const SizedBox(height: 8),
              keyVal7('Total Pembayaran', rupiahFormat(data['total_pembayaran'])),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: HexColor('#EFEFEF'),
                ),
                child: Expanded(
                  child: TextWidget(
                    text: 'Total pengembalian dana untuk transaksi Anda adalah Rp 550.000',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#5F5F5F'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Button1(btntext: 'Lihat Pendanaan Lainnya'),
            ],
          ),
        ),
      ),
    );
  }

  Widget produkWidget(Map<String, dynamic> data) {
    if ((data['kdTrans'] == 'PNP' || data['kdTrans'] == 'PRP' || data['kdTrans'] == 'PBL') &&
        data['idProduk'] == 1) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                PortofolioDetail.routeName,
                arguments: PortofolioDetail(
                  idAgreement: int.parse(data['noPerjanjian']),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/lender/pendanaan/maxi_default.png',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Subtitle2Extra(text: data['nmProduk']),
                          const SizedBox(height: 4),
                          Subtitle4(
                            text: data['noPerjanjian'],
                            color: HexColor('#AAAAAA'),
                          ),
                        ],
                      )
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 16,
                    color: HexColor(lenderColor),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
    if ((data['kdTrans'] == 'PNP' || data['kdTrans'] == 'PRP' || data['kdTrans'] == 'PBL') &&
        data['idProduk'] == 2) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                PortofolioDetail.routeName,
                arguments: PortofolioDetail(
                  idAgreement: data['noPerjanjian'],
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/lender/portofolio/Car_1.png',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: data['nmProduk'], fontSize: 12, fontWeight: FontWeight.w500),
                          const SizedBox(height: 4),
                          Subtitle4(
                            text: data['noPerjanjian'],
                            color: HexColor('#AAAAAA'),
                          ),
                        ],
                      )
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 16,
                    color: HexColor(lenderColor),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
