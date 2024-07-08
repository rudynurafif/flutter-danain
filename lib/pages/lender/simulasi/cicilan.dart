import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class SimulasiCicilanLender extends StatefulWidget {
  final SimulasiPendanaanBloc sBloc;
  const SimulasiCicilanLender({
    super.key,
    required this.sBloc,
  });

  @override
  State<SimulasiCicilanLender> createState() => _SimulasiCicilanLenderState();
}

class _SimulasiCicilanLenderState extends State<SimulasiCicilanLender> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.sBloc;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Jangka Waktu Angsuran'),
        const SizedBox(height: 8),
        tenorWidget(bloc),
        const SizedBox(height: 24),
        resultWidget(bloc),
      ],
    );
  }

  Widget tenorWidget(SimulasiPendanaanBloc bloc) {
    return StreamBuilder<List<ListProductResponse>>(
      stream: bloc.listProdukStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listProduk = snapshot.data ?? [];
          return StreamBuilder<ListProductResponse>(
            stream: bloc.produkTenorStream,
            builder: (context, snapshot) {
              final dataSelected = snapshot.data ??
                  listProduk
                      .where(
                        (element) => element.tenor == 6,
                      )
                      .first;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: listProduk.map(
                  (data) {
                    return GestureDetector(
                      onTap: () {
                        bloc.produkTenorChange(data);
                        bloc.isLoadingChange(true);
                        bloc.postCicilan();
                      },
                      child: jangkaWaktuMenu(
                        context,
                        data.detail,
                        data.tenor,
                        dataSelected.tenor,
                      ),
                    );
                  },
                ).toList(),
              );
            },
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget jangkaWaktuMenu(
    BuildContext context,
    String text,
    int index,
    int currentIndex,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.7,
      // height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: currentIndex == index ? const Color(0xffF4FEF5) : Colors.white,
        border: Border.all(
          width: 1,
          color: currentIndex == index
              ? const Color(0xffBDDCCA)
              : const Color(0xffDDDDDD),
        ),
      ),
      child: Center(
        child: Subtitle2(
          text: text,
          color: currentIndex == index
              ? HexColor(lenderColor)
              : const Color(0xff777777),
        ),
      ),
    );
  }

  Widget resultWidget(SimulasiPendanaanBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFF1FCF4),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDCECE0)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Subtitle2Extra(text: 'Estimasi Pengembalian'),
          const SizedBox(height: 16),
          StreamBuilder<Map<String, dynamic>>(
            stream: bloc.cicilanResponse,
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  keyVal7(
                    'Pokok Pendanaan',
                    rupiahFormat(data['pokokPendana'] ?? 0),
                  ),
                  const SizedBox(height: 12),
                  keyVal7(
                    'Bunga',
                    '${data['rate'] ?? 0}% p.a',
                  ),
                  const SizedBox(height: 12),
                  keyVal7(
                    'Imbal Hasil',
                    rupiahFormat(data['imbalHasil'] ?? 0),
                  ),
                  const SizedBox(height: 16),
                  dividerDashed(context),
                  const SizedBox(height: 16),
                  keyValExtra(
                    'Total Pengembalian',
                    rupiahFormat(data['total'] ?? 0),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
