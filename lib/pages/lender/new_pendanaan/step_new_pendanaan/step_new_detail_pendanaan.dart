import 'package:flutter/material.dart';

import '../../../../widgets/widget_element.dart';
import '../components/detail_pendanaan.dart/detail_component.dart';
import '../new_detail_pendanaan/new_detail_pendanaan_bloc.dart';

class StepNewDetailPendanaan extends StatefulWidget {
  const StepNewDetailPendanaan({
    super.key,
    required this.bloc,
  });

  final NewDetailPendanaanBloc bloc;

  @override
  State<StepNewDetailPendanaan> createState() => _StepNewDetailPendanaanState();
}

class _StepNewDetailPendanaanState extends State<StepNewDetailPendanaan> {
  @override
  void initState() {
    super.initState();
    widget.bloc.getNewDetailPendanaan();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.bloc.getNewDetailPendanaan();
        widget.bloc.getDataHome();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(
            context: context,
            isLeading: true,
            title: 'Detail Pendanaan',
          ),
        ),
        body: StreamBuilder<dynamic>(
          stream: widget.bloc.detailPendanaan,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final pendanaan = snapshot.data!;
              print(pendanaan);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      DetailTitle(
                        image: pendanaan['detail']['img'],
                        namaProduk: pendanaan['detail']['namaProduk'],
                        noPp: pendanaan['detail']['noPengajuan'],
                      ),
                      const SizedBox(height: 16),
                      JumlahPendanaan(
                        pokokHutang: pendanaan['detail']['pokokHutang'],
                        potensiPendanaan: pendanaan['detail']['potensiPengembalian'],
                        bungaEfektif: pendanaan['detail']['ratePendana'],
                        tenor: pendanaan['detail']['tenor'],
                        tujuan: pendanaan['detail']['tujuan'],
                        listAngsuran: pendanaan['detail']['angsuranDetail'] ?? [],
                        bungaHutang: pendanaan['detail']['bungaHutang'],
                        keyAngsuran: 'nourut',
                        keyKeterangan: 'keterangan',
                        keyNominal: 'angsuran',
                        keyPokokHutang: 'pokokHutang',
                        onTapRiwayat: () {},
                      ),
                      const SizedBox(height: 16),
                      SkemaPendanaanWidget(
                        angsuranPokok: pendanaan['skemaPendanaan']['angsuranPokok'],
                        angsuranBunga: pendanaan['skemaPendanaan']['angsuranBunga'],
                      ),
                      const SizedBox(height: 16),
                      AgunanWidget(
                        jenisKendaraan: pendanaan['agunan']['jenisKendaraan'] ?? '',
                        merek: pendanaan['agunan']['merek'] ?? 'Merek',
                        model: pendanaan['agunan']['model'] ?? 'Model',
                        type: pendanaan['agunan']['type'] ?? 'Type',
                        image: pendanaan['agunan']['img'],
                        cc: pendanaan['agunan']['cc'] ?? '',
                        tahunProduksi: pendanaan['agunan']['tahun'],
                        namaKendaraan: pendanaan['agunan']['namaKendaraan'],
                        kondisiKendaraan: pendanaan['agunan']['kondisi'],
                        keterangan: pendanaan['agunan']['keterangan'],
                        namaMitra: pendanaan['agunan']['dataCabang']['namaCabang'],
                      ),
                      const SizedBox(height: 16),
                      InformasiPeminjamWidget(
                        namaBorrower: pendanaan['informasiPeminjam']['nama_borrower'],
                        kreditSkor: pendanaan['informasiPeminjam']['kredit_skor'],
                      )
                    ],
                  ),
                ),
              );
            }
            return const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    DetailTitleLoading(),
                    SizedBox(height: 16),
                    JumlahPendanaanLoading(),
                    SizedBox(height: 16),
                    SkemaPendanaanLoading(),
                    SizedBox(height: 16),
                    AgunanLoading(),
                    SizedBox(height: 16),
                    InformasiPeminjamLoading(),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomDanainLender(bloc: widget.bloc),
      ),
    );
  }
}
