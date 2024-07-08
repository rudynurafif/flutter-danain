import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_bloc2.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/simulasi/simulasi_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class KonfirmasiAcceptPinjaman extends StatefulWidget {
  final KonfirmasiPinjamanBloc2 ppBloc;
  const KonfirmasiAcceptPinjaman({super.key, required this.ppBloc});

  @override
  State<KonfirmasiAcceptPinjaman> createState() => _AcceptPinjamanState();
}

class _AcceptPinjamanState extends State<KonfirmasiAcceptPinjaman> {
  int idPenyerahan = 0;
  String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('E, d MMM y, HH:mm');
    return dateFormat.format(date);
  }

  @override
  void initState() {
    widget.ppBloc.stepControl(4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: widget.ppBloc.konfirmasiError,
      builder: (context, snapshot) {
        return bodyBuilder(context);
      },
    );
  }

  Widget bodyBuilder(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/process.svg'),
          const SizedBox(height: 32),
          const Headline1(text: 'Sedang Diproses'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Subtitle2(
              text:
                  'Mohon ditunggu ya, pencairan dana ke rekening Anda sedang diproses',
              color: HexColor('#777777'),
              align: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          dividerFull(context),
          const SizedBox(height: 16),
          StreamBuilder<Map<String, dynamic>?>(
            stream: widget.ppBloc.response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? {};
                print('check data response valid $data');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: pinjamanDetail(data),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 94,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Button1(
            btntext: 'Penyerahan BPKB',
            action: () => showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                widget.ppBloc.stepControl(4);
                return penyerahanBPKB();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> alertBack(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ModalPopUpNoClose(
          icon: 'assets/images/icons/check.svg',
          title: 'Request Berhasil',
          message:
              'Berhasil request penyerahan BPKB melalui surveyor. Silakan cek email Anda untuk melihat surat kuasa penerimaan.',
          actions: [
            ButtonWidget(
              paddingY: 9,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              titleColor: Colors.white,
              title: 'OK',
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushNamedAndRemoveUntil(
                    context, HomePage.routeName, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Widget penyerahanBPKB() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: SizedBox(
        height: 324,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Container(
              color: HexColor('#DDDDDD'),
              width: 42,
              height: 4,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Headline2500(text: 'Penyerahan BPKB'),
                  const SizedBox(height: 8),
                  Headline4500(
                    text: 'Pilih metode penyerahan BPKB berikut ini',
                    color: HexColor('#777777'),
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder<int>(
                    stream: widget.ppBloc.isPenyerahanBpkbStream,
                    builder: (context, snapshot) {
                      var isPenyerahans = snapshot.data ?? 0;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KendaraanComponent(
                                current: isPenyerahans,
                                index: 2,
                                title: 'Mandiri ke Mitra',
                                image:
                                    'assets/images/icons/icMitra_borrower.svg',
                                onTap: () {
                                  if (isPenyerahans != 2) {
                                    setState(() {
                                      isPenyerahans = 2;
                                    });
                                    widget.ppBloc.isPenyerahanBpkb(2);
                                  }
                                },
                              ),
                              KendaraanComponent(
                                current: isPenyerahans,
                                index: 1,
                                title: 'Melalui Surveyor',
                                image:
                                    'assets/images/icons/icSurveyor_borrower.png',
                                onTap: () {
                                  if (isPenyerahans != 1) {
                                    setState(() {
                                      isPenyerahans = 1;
                                    });
                                    widget.ppBloc.isPenyerahanBpkb(1);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 69,
            padding: const EdgeInsets.only(right: 24, bottom: 24, left: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder<int>(
                  stream: widget.ppBloc.isPenyerahanBpkbStream,
                  builder: (context, snapshot) {
                    var isPenyerahans = snapshot.data ?? 0;
                    return Button1(
                      btntext: 'Lanjut',
                      color: isPenyerahans == 0
                          ? HexColor('#ADB3BC')
                          : HexColor(borrowerColor),
                      action: isPenyerahans == 0
                          ? null
                          : () {
                              widget.ppBloc
                                  .postKonfirmasiPenyerahanKonfirmasPinjamanCND();
                              if (isPenyerahans == 2) {
                                Navigator.pop(context);
                                widget.ppBloc.stepControl(5);
                              } else {
                                alertBack(context);
                              }
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pinjamanDetail(Map<String, dynamic> data) {
    print('test detail data ${data}');
    DateTime waktu = DateTime.parse(data['waktu']);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Detail Pencairan Pinjaman'),
        const SizedBox(height: 16),
        keyVal('Pinjaman',
            rupiahFormat(data['pinjaman_nominal'] ?? data['pinjamanNominal'])),
        const SizedBox(height: 8),
        keyVal2('Total Pencairan',
            rupiahFormat(data['total_pencairan'] ?? data['totalPencainran'])),
        const SizedBox(height: 8),
        keyVal2('Rekening Tujuan',
            data['rekening_tujuan'] ?? data['rekeningTujuan']),
        const SizedBox(height: 8),
        cashBackControl(data['cash_back'] ?? 0),
        const SizedBox(height: 8),
        keyVal('Waktu Pengajuan', formatDateFull(waktu.toString())),
      ],
    );
  }

  Widget cashBackControl(int cashBack) {
    if (cashBack == 0) {
      return const SizedBox.shrink();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          keyVal('Cashback Pinjaman', rupiahFormat(cashBack)),
          const SizedBox(height: 8),
        ],
      );
    }
  }
}
