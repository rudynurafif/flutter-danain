import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/Cnd_component.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/bloc/pengajuan_bloc.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class StepProses extends StatefulWidget {
  final PengajuanCashDriveBloc pengajuanBloc;
  const StepProses({
    super.key,
    required this.pengajuanBloc,
  });

  @override
  State<StepProses> createState() => _StepProsesState();
}

class _StepProsesState extends State<StepProses> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.pengajuanBloc;
    return Parent(
      child: StreamBuilder<Map<String, dynamic>?>(
        stream: bloc.response.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            final alamat = data['data'] ?? {};
            final kendaraan = data['detailKendaraan'] ?? {};
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 200,
                  ),
                  const SpacerV(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const TextWidget(
                          text: 'Pengajuan Sedang Dalam Proses',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          align: TextAlign.center,
                        ),
                        const SpacerV(),
                        TextWidget(
                          text:
                              'Selanjutnya Anda akan dihuhubungi oleh tim kami dan pastikan berada di tempat sesuai dengan jadwal kedatangan survey dan menyiapkan beberapa dokumen di bawah ini.',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: HexColor('#777777'),
                          align: TextAlign.center,
                        ),
                        const SpacerV(value: 24),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SuratComponent(text: 'STNK'),
                            SuratComponent(text: 'BPKB'),
                            SuratComponent(text: 'Faktur (opsional)'),
                          ],
                        ),
                        const SpacerV(value: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SuratComponent(text: 'KTP Pasangan (opsional)'),
                            SuratComponent(text: 'Buku Tabungan'),
                          ],
                        ),
                        const SpacerV(value: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SuratComponent(text: 'Bon/Nota'),
                            SuratComponent(
                              text: 'PBB / Slip Pembayaran Listrik',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SpacerV(value: 24),
                  const DividerWidget(height: 6),
                  const SpacerV(value: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        PinjamanComponent(
                          pengajuan: kendaraan['nominal'] ?? 0,
                          jenis: kendaraan['jenisKendaraan'] ?? '',
                          merk: kendaraan['merek'] ?? '',
                          tipe: kendaraan['type'] ?? '',
                          model: kendaraan['model'] ?? '',
                          plat: kendaraan['noPolisi'] ?? '',
                          tahun: kendaraan['tahunProduksi'] ?? '0000',
                          cc: kendaraan['cc'] ?? '0',
                          noStnk: kendaraan['noSTNK'] ?? '',
                          noBpkb: kendaraan['noBPKB'] ?? '',
                          jenisKendaraan:
                              kendaraan['jenisKendaraan'] == 'Mobil' ? 1 : 2,
                        ),
                        const SpacerV(value: 16),
                        LokasiComponent(
                          alamatUtama: alamat['alamat'],
                          alamatDetail: alamat['detailAlamat'],
                          tanggalSurvey: alamat['tglsuryey'],
                          maps: 'maps',
                        ),
                      ],
                    ),
                  ),
                  const SpacerV(value: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ButtonWidget(
                      title: 'Kembali ke beranda',
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomePage.routeName,
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SpacerV(value: 24),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: HexColor(primaryColorHex),
            ),
          );
        },
      ),
    );
  }
}
