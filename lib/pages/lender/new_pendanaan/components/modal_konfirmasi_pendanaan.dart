import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/step_new_pendanaan/step_new_document.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_detail_pendanaan/new_detail_pendanaan_bloc.dart';
import 'detail_pendanaan.dart/detail_title.dart';
import 'detail_pendanaan.dart/row_data.dart';
import 'pop_up_verifikasi_pendanaan.dart';

class ModalKonfirmasiPendanaan extends StatefulWidget {
  const ModalKonfirmasiPendanaan({
    super.key,
    required this.pendanaan,
    required this.bloc,
  });

  final Map<String, dynamic> pendanaan;
  final NewDetailPendanaanBloc bloc;

  @override
  State<ModalKonfirmasiPendanaan> createState() => _ModalKonfirmasiPendanaanState();
}

class _ModalKonfirmasiPendanaanState extends State<ModalKonfirmasiPendanaan> {
  bool isCheckModal = false;

  @override
  void initState() {
    super.initState();
    widget.bloc.getDataHome();
    widget.bloc.isAgreePP.listen((isAgree) {
      setState(() {
        isCheckModal = isAgree;
      });
    });
  }

  void _showCustomModalBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      builder: (context) => child,
    );
  }

  void _handleCheck() async {
    widget.bloc.getDocumentP3();

    if (isCheckModal) {
      setState(() {
        isCheckModal = false;
        widget.bloc.agreementPP(false);
      });
    } else {
      final isCheckFromDoc = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return StepNewDokumen(bloc: widget.bloc);
          },
        ),
      );
      if (isCheckFromDoc != null && isCheckFromDoc) {
        setState(() {
          isCheckModal = true;
          widget.bloc.agreementPP(true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  text: 'Konfirmasi Pendanaan',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: HexColor('#AAAAAA'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                DetailTitle(
                  image: widget.pendanaan['detail']['img'],
                  namaProduk: widget.pendanaan['detail']['namaProduk'],
                  noPp: widget.pendanaan['detail']['noPengajuan'],
                ),
                dividerFull2(context),
                RowData(
                  title: 'Jumlah Pendanaan',
                  data: rupiahFormat(widget.pendanaan['detail']['pokokHutang']),
                  color: '#777777',
                ),
                const SizedBox(height: 8),
                RowData(
                  title: 'Bunga Pendanaan',
                  data: '${widget.pendanaan['detail']['ratePendana']}% p.a',
                  color: '#777777',
                ),
                const SizedBox(height: 8),
                RowData(
                  title: 'Tenor',
                  data: '${widget.pendanaan['detail']['tenor']} bulan',
                  color: '#777777',
                ),
                const SizedBox(height: 8),
                const RowData(
                  title: 'Skema Bayar',
                  data: 'Angsuran',
                  color: '#777777',
                ),
                const SizedBox(height: 8),
                dividerDashed(context),
                const SizedBox(height: 8),
                RowData(
                  title: 'Potensi Pengembalian',
                  data: rupiahFormat(widget.pendanaan['detail']['potensiPengembalian']),
                  color: '#777777',
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _handleCheck,
                  child: checkBoxLender(
                    isCheckModal,
                    Row(
                      children: [
                        const Subtitle2(text: acceptSyarat1),
                        const SizedBox(width: 3),
                        Subtitle2(
                          text: 'Perjanjian Pendanaan',
                          color: HexColor(lenderColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
            StreamBuilder<dynamic>(
              stream: widget.bloc.dataHome,
              builder: (context, snapshot) {
                final dataBeranda = snapshot.data;
                return StreamBuilder(
                  stream: bloc.isAgreePP,
                  builder: (context, snapshot) {
                    final isCheck = snapshot.data ?? false;
                    return Button1(
                      btntext: 'Lanjut',
                      color: isCheck ? HexColor(lenderColor) : HexColor('#ADB3BC'),
                      action: isCheck
                          ? () {
                              /*
                              Yang bener
                              Kalau aman, kode aktivasi != 0 atau 1
                              Data diri belum lengkap, kode aktivasi = 0
                              Akun belum aktif, kode aktivasi = 9
                            */

                              // Sementara
                              if (dataBeranda['status']['Aktivasi'] == 1) {
                                bloc.checkSaldoFunction(widget.pendanaan['detail']['pokokHutang']);
                                Navigator.pop(context);
                              }
                              if (dataBeranda['status']['Aktivasi'] == 0) {
                                _showCustomModalBottomSheet(
                                  context,
                                  notVerifiedPopUp(context),
                                );
                              }
                              if (dataBeranda['status']['Aktivasi'] == 9) {
                                _showCustomModalBottomSheet(
                                  context,
                                  waitingVerifiedPopUp(context),
                                );
                              }
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
