import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class StepDetailAngsuran extends StatefulWidget {
  final CicilEmas2Bloc cBloc;
  const StepDetailAngsuran({super.key, required this.cBloc});

  @override
  State<StepDetailAngsuran> createState() => _StepDetailAngsuranState();
}

class _StepDetailAngsuranState extends State<StepDetailAngsuran> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.cBloc;
    return Scaffold(
      appBar: previousTitleCustom(
        context,
        'Pembayaran',
        () {
          bloc.stepChange(2);
          // cicilBloc.ajuanCicilanCancel();
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Detail Transaksi Cicil Emas'),
              const SizedBox(height: 24),
              const Headline5(text: 'Total Pembayaran'),
              const SizedBox(height: 8),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.detailPembayaran,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        keyVal('Harga Perolehan Emas',
                            rupiahFormat(data['hargaPerolehanEmas'])),
                        const SizedBox(height: 8),
                        keyVal('Bunga', rupiahFormat(data['bunga'])),
                        const SizedBox(height: 8),
                        keyVal('Biaya Administrasi',
                            rupiahFormat(data['biayaAdmin'])),
                        const SizedBox(height: 8),
                        keyVal(
                            'Fee Jasa Mitra', rupiahFormat(data['jasaMitra'])),
                        const SizedBox(height: 8),
                        keyVal('Diskon', rupiahFormat(data['diskon'])),
                        const SizedBox(height: 8),
                        dividerDashed(context),
                        const SizedBox(height: 8),
                        keyVal('Total Pembayaran', rupiahFormat(data['total'])),
                        const SizedBox(height: 8),
                        dividerFullNoPadding(context),
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      dividerDashed(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      dividerFullNoPadding(context),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),

              //angsuran
              const Headline5(text: 'Info Angsuran'),
              const SizedBox(height: 8),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.infoAngsuran,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        keyVal(
                            'Jangka Waktu Angsuran', '${data['tenor']} Bulan'),
                        const SizedBox(height: 8),
                        keyVal('Angsuran Bulanan',
                            rupiahFormat(data['angsuranBulanan'])),
                        const SizedBox(height: 8),
                        keyVal('Fee Jasa Mitra Bulanan',
                            rupiahFormat(data['jasaMitra'])),
                        const SizedBox(height: 8),
                        dividerDashed(context),
                        const SizedBox(height: 8),
                        keyVal(
                          'Total Angsuran Bulanan',
                          rupiahFormat(data['total']),
                        ),
                        const SizedBox(height: 8),
                        dividerFullNoPadding(context),
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      dividerDashed(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      dividerFullNoPadding(context),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),

              //angsuran pertama
              const Headline5(text: 'Total Angsuran Pertama'),
              const SizedBox(height: 8),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.angsuranPertamaStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        keyVal(
                          'Angsuran Pertama',
                          rupiahFormat(data['HargaEmas']),
                        ),
                        const SizedBox(height: 8),
                        keyVal(
                          'Biaya Administrasi',
                          rupiahFormat(data['BiayaAdmin']),
                        ),
                        const SizedBox(height: 8),
                        dividerDashed(context),
                        const SizedBox(height: 8),
                        keyVal(
                          'Total Angsuran Pertama',
                          rupiahFormat(data['Total']),
                        ),
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                      const SizedBox(height: 8),
                      dividerDashed(context),
                      const SizedBox(height: 8),
                      keyValLoading(context),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: buttonBottom(bloc),
    );
  }

  Widget buttonBottom(CicilEmas2Bloc bloc) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 94,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1E3B4A74),
            blurRadius: 12,
            offset: Offset(0, -2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle2(
                text: 'Total Angsuran Pertama',
                color: Colors.grey,
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.angsuranPertamaStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final angsuran = snapshot.data!;
                    return Headline2(
                      text: rupiahFormat(angsuran['Total']),
                    );
                  }
                  return Headline2(text: rupiahFormat(0));
                },
              )
            ],
          ),
          ButtonCustomWidth(
            btntext: 'Bayar',
            action: () {
              bloc.reqOtpClick();
            },
          )
        ],
      ),
    );
  }
}
