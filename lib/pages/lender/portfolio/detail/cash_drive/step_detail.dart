import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/dokumen/html/dokumen_html_page.dart';
import 'package:flutter_danain/pages/dokumen/pdf/dokumen_page.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/components/detail_pendanaan.dart/detail_component.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/detail_portofolio_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepDetailCashDrive extends StatefulWidget {
  final DetailPortoBloc dpBloc;
  const StepDetailCashDrive({
    super.key,
    required this.dpBloc,
  });

  @override
  State<StepDetailCashDrive> createState() => _StepDetailCashDriveState();
}

class _StepDetailCashDriveState extends State<StepDetailCashDrive> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.dpBloc;

    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.detailDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarWidget(
                context: context,
                isLeading: true,
                title: 'Detail Pendanaan',
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    DetailTitle(
                      image: data['detail']['link'],
                      namaProduk: data['detail']['nmProduk'],
                      noPp: data['detail']['noPerjanjian'],
                    ),
                    const SizedBox(height: 16),
                    JumlahPendanaan(
                      pokokHutang: data['detail']['pokokHutang'],
                      potensiPendanaan: data['detail']['potensiPengembalian'],
                      bungaEfektif: data['detail']['ratePendana'],
                      tenor: data['detail']['tenor'],
                      tujuan: data['detail']['tujuan'],
                      listAngsuran: data['Angsuran'] ?? [],
                      bungaHutang: data['detail']['bungaHutang'],
                      keyAngsuran: 'nourut',
                      keyKeterangan: 'keterangan',
                      keyNominal: 'bunga',
                      keyPokokHutang: 'pokokHutang',
                      onTapRiwayat: () {
                        bloc.stepChange(2);
                      },
                      isRiwayat: true,
                    ),
                    const SizedBox(height: 16),
                    SkemaPendanaanWidget(
                      angsuranPokok:
                          data['skemaPendanaan']['angsuranPokok'] ?? 0,
                      angsuranBunga:
                          data['skemaPendanaan']['angsuranBunga'] ?? 0,
                      isDetail: true,
                      tanggalMulai: data['detail']['tglPencairan'] ?? '',
                      tanggalJatuhTempo: data['detail']['tglJt'] ?? '',
                    ),
                    const SizedBox(height: 16),
                    AgunanWidget(
                      jenisKendaraan: data['agunan']['jenisKendaraan'] ?? '',
                      merek: data['agunan']['merek'] ?? 'Merek',
                      model: data['agunan']['model'] ?? 'Model',
                      type: data['agunan']['type'] ?? 'Type',
                      image: data['agunan']['link'] ?? '',
                      cc: data['agunan']['cc'] ?? '',
                      tahunProduksi: data['agunan']['tahun'] ?? '',
                      namaKendaraan: data['agunan']['namaKendaraan'] ?? '',
                      kondisiKendaraan: data['agunan']['kondisi'] ?? '',
                      keterangan: data['agunan']['keterangan'] ?? '',
                      namaMitra:
                          data['agunan']['dataCabang']['namaCabang'] ?? '',
                    ),
                    const SizedBox(height: 16),
                    InformasiPeminjamWidget(
                      namaBorrower:
                          data['informasiPeminjam']['nama_borrower'] ?? '',
                      kreditSkor:
                          data['informasiPeminjam']['kredit_skor'] ?? '',
                    ),
                    const SpacerV(value: 16),
                    dokumenWidget(
                      idPengajuan: data['detail']['idPengajuan'] ?? 0,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget dokumenWidget({
    required int idPengajuan,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffEEEEEE),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'Dokumen',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SpacerV(value: 16),
          dokumenMenu(
            title: 'Perjanjian Pendanaan',
            param: {
              'idPengajuan': idPengajuan,
              'cetak': 'PP',
              'bucket': 'bpkb-lender',
              'view': 'view',
              'borrower_lender': 'lender',
            },
          ),
          const SpacerV(value: 16),
          dokumenMenu(
            title: 'Perjanjian Penyaluran Pendanaan',
            param: {
              'idPengajuan': idPengajuan,
              'cetak': 'PPP',
              'bucket': 'bpkb-lender',
              'view': 'view',
              'borrower_lender': 'lender',
            },
          ),
        ],
      ),
    );
  }

  Widget dokumenMenu({
    required String title,
    Map<String, dynamic> param = const {},
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          DokumenHtmlPage.routeName,
          arguments: DokumenHtmlPage(
            link: 'api/beedanaingenerate/v1/dokumen/PP',
            param: param,
            title: 'Detail Dokumen',
          ),
        );
      },
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/lender/portofolio/dokumen.svg',
          ),
          const SpacerH(value: 4),
          TextWidget(
            text: title,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Constants.get.lenderColor,
          ),
        ],
      ),
    );
  }
}
