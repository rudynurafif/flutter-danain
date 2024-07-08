import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/component/pembayaran.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/detail_portofolio_bloc.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class StepRiwayatCashDrive extends StatefulWidget {
  final DetailPortoBloc pBloc;
  const StepRiwayatCashDrive({
    super.key,
    required this.pBloc,
  });

  @override
  State<StepRiwayatCashDrive> createState() => _StepRiwayatCashDriveState();
}

class _StepRiwayatCashDriveState extends State<StepRiwayatCashDrive> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.pBloc;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Riwayat Pengembalian',
          leadingAction: () {
            bloc.stepChange(1);
          },
        ),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.detailDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            return SingleChildScrollView(
              child: Column(
                children: [
                  detailRiwayat(data),
                  const SpacerV(value: 16),
                  const DividerWidget(
                    height: 6,
                    color: Color(0xffF5F9F6),
                  ),
                  riwayatPembayaran(data['Angsuran'] ?? [])
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget detailRiwayat(Map<String, dynamic> riwayat) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          keyValComponent(
            title: 'Total Pengembalian',
            value: rupiahFormat(riwayat['totalPengembalian'] ?? 0),
            sizeValue: 16,
          ),
          const SpacerV(value: 8),
          const DividerWidget(height: 1),
          const SpacerV(value: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: keyValComponent(
                  title: 'Pokok dana diterima',
                  value: rupiahFormat(riwayat['riwayatPengembalian']['pokokDanaDiterima'] ?? 0),
                ),
              ),
              Flexible(
                child: keyValComponent(
                  title: 'Bunga diterima',
                  value: rupiahFormat(riwayat['riwayatPengembalian']['bungaDiterima'] ?? 0),
                ),
              ),
            ],
          ),
          const SpacerV(value: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: keyValComponent(
                  title: 'Denda diterima',
                  value: rupiahFormat(riwayat['riwayatPengembalian']['dendaDiterima'] ?? 0),
                ),
              ),
              Flexible(
                child: keyValComponent(
                  title: 'Outstanding',
                  value: rupiahFormat(riwayat['riwayatPengembalian']['outstanding'] ?? 0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget riwayatPembayaran(List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpacerV(value: 16),
          const TextWidget(
            text: 'Detail Pengembalian',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SpacerV(value: 16),
          Column(
            children: data.asMap().entries.map((entry) {
              final int index = entry.key;
              final e = entry.value;

              return PembayaranWidget(
                keterangan: e['status'] ?? '',
                noUrut: e['nourut'] ?? 1,
                tgl: e['tglJt'] ?? '1-01-01T00:00:00',
                nominal: e['bunga'] ?? 0,
                isStatus: e['isStatus'] ?? 0,
                bunga: e['bunga'] ?? 0,
                total: e['nilaiBayar'] ?? 0,
                denda: e['denda'] ?? 0,
                pokokDana: e['pokokHutang'] ?? 0,
                tglBayar: e['tglBayar'] ?? '0001-01-01T00:00:00Z',
                isLast: index + 1 == data.length ? true : false,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget keyValComponent({
    required String title,
    required String value,
    double sizeValue = 14,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: title,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: const Color(0xffAAAAAA),
        ),
        const SpacerV(value: 4),
        TextWidget(
          text: value,
          fontSize: sizeValue,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
