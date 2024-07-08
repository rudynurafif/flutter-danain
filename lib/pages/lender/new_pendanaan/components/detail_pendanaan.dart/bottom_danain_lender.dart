import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_detail_pendanaan/new_detail_pendanaan_bloc.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/components/modal_konfirmasi_pendanaan.dart';

class BottomDanainLender extends StatelessWidget {
  const BottomDanainLender({
    super.key,
    required this.bloc,
  });

  final NewDetailPendanaanBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: bloc.detailPendanaan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pendanaan = snapshot.data;
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Button1Lender(
                  btntext: 'Danain',
                  color: HexColor(lenderColor),
                  action: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      builder: (context) {
                        return ModalKonfirmasiPendanaan(
                          pendanaan: pendanaan,
                          bloc: bloc,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
