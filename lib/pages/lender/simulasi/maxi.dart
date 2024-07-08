import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class SimulasiMaxiLender extends StatefulWidget {
  final SimulasiPendanaanBloc sBloc;
  const SimulasiMaxiLender({
    super.key,
    required this.sBloc,
  });

  @override
  State<SimulasiMaxiLender> createState() => _SimulasiMaxiLenderState();
}

class _SimulasiMaxiLenderState extends State<SimulasiMaxiLender> {
  final StreamController<double> debounceController =
      StreamController<double>.broadcast();
  Stream<double> get _debouncedValue => debounceController.stream.debounceTime(
        const Duration(milliseconds: 50),
      );

  @override
  void initState() {
    super.initState();
    _debouncedValue.listen((double value) {
      widget.sBloc.postMaxi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.sBloc;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tenorWidget(bloc),
        const SizedBox(height: 24),
        resultWidget(bloc),
      ],
    );
  }

  Widget tenorWidget(SimulasiPendanaanBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.tenorPinjamanStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Subtitle2(
                  text: 'Jangka waktu pelunasan',
                  color: HexColor('#777777'),
                ),
                Headline3500(text: '${data.toString()} hari')
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FractionallySizedBox(
                widthFactor: 1.1,
                child: Slider(
                  value: data.toDouble(),
                  max: 180,
                  min: 1,
                  label: data.toString(),
                  activeColor: HexColor(lenderColor),
                  inactiveColor: const Color(0xffEDEDED),
                  thumbColor: HexColor(lenderColor),
                  onChanged: (double value) {
                    bloc.tenorPinjamanChange(value.toInt());
                    bloc.isLoadingChange(true);
                    debounceController.add(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Subtitle4(
                  text: 'Min. 1 hari',
                  color: HexColor('#777777'),
                ),
                Subtitle4(
                  text: 'Max. 180 hari',
                  color: HexColor('#777777'),
                ),
              ],
            ),
          ],
        );
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
      width: MediaQuery.of(context).size.width / 4,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: currentIndex == index ? const Color(0xffE9F6EB) : Colors.white,
        border: Border.all(
          width: 1,
          color: currentIndex == index
              ? const Color(0xff8EB69B)
              : const Color(0xffDDDDDD),
        ),
      ),
      child: Center(
        child: Subtitle2(
          text: text,
          color: currentIndex == index
              ? const Color(0xff24663F)
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
            stream: bloc.maxiResponse,
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  keyVal7(
                    'Pokok Pendanaan',
                    rupiahFormat(data['pokokPendanaan'] ?? 0),
                  ),
                  const SizedBox(height: 12),
                  keyVal7(
                    'Bunga',
                    '${data['bunga'] ?? 0}% p.a',
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
                    rupiahFormat(data['totalPengembalian'] ?? 0),
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
