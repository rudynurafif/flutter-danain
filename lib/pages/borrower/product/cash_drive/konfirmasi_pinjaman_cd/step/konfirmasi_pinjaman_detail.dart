import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_PreviousTitle.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class KonfirmasiPinjamanDetail extends StatefulWidget {
  final KonfirmasiPinjamanBloc2 ppBloc;
  const KonfirmasiPinjamanDetail({super.key, required this.ppBloc});

  @override
  State<KonfirmasiPinjamanDetail> createState() =>
      _KonfirmasiPinjamanDetaillState();
}

class _KonfirmasiPinjamanDetaillState extends State<KonfirmasiPinjamanDetail> {
  @override
  void initState() {
    super.initState();
  }

  bool isAgree = false;
  @override
  Widget build(BuildContext context) {
    final bloc = widget.ppBloc;
    return Scaffold(
      appBar: previousTitle(context, 'Konfirmasi Pinjaman'),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.dataPinjamanStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            print('detail pinjaman konfirm $data');
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  section2Widget(data['agunan']),
                  const DividerWidget(height: 6),
                  const SizedBox(height: 16),
                  section3Widget(data['informasiPinjaman']),
                  section3AngsuranWidget(data['infoAngsuran']),
                  section3PelunasanWidget(data['pelunasanAkhir']),
                  dividerFull(context),
                  section4Widget(data['dataRekening']),
                  const SizedBox(height: 16),
                  agreeCheckBox(bloc),
                  const SizedBox(height: 24),
                  buttonAgree(bloc),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Subtitle2(text: snapshot.error.toString()),
            );
          }
          return Center(
              child: Image.asset('assets/images/icons/loading_danain.png'));
        },
      ),
    );
  }

  Widget agreeCheckBox(KonfirmasiPinjamanBloc2 bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<bool>(
        stream: bloc.checkPinjaman,
        builder: (context, snapshot) {
          final isCheck = snapshot.data ?? false;
          return StreamBuilder<Map<String, dynamic>>(
            stream: bloc.dataPinjamanStream,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () {
                  if (isCheck == true) {
                    bloc.checkPinjamanControl(false);
                  } else {
                    bloc.getDocumentPerjanjian();
                    bloc.stepControl(10);
                  }
                },
                child: checkBoxBorrower(
                  isCheck,
                  const Row(
                    children: [
                      Subtitle2(text: acceptSyarat1),
                      SizedBox(width: 2.0),
                      Subtitle2(
                        text: 'Perjanjian Pinjaman',
                        color: Color(0xff288C50),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buttonAgree(KonfirmasiPinjamanBloc2 bloc) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: StreamBuilder<bool>(
          stream: bloc.checkPinjaman,
          builder: (context, snapshot) {
            final isCheck = snapshot.data ?? false;
            return Button1(
              btntext: 'Konfirmasi',
              color: isCheck ? null : HexColor('#ADB3BC'),
              action: isCheck
                  ? () {
                      bloc.konfirmasiPinjaman();
                    }
                  : null,
            );
          },
        ));
  }

  Widget section2Widget(Map<String, dynamic> data) {
    print('list data pinjaman $data');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3(text: 'Agunan'),
          const SizedBox(height: 8),
          keyVal13400('Jenis Kendaraan', data['jenisKendaraan']),
          const SizedBox(height: 8),
          keyVal13400('Merek', data['merek']),
          const SizedBox(height: 8),
          keyVal13400('Tipe', data['type']),
          const SizedBox(height: 8),
          keyVal13400('Model', data['model']),
          const SizedBox(height: 8),
          keyVal13400('CC', data['cc']),
          const SizedBox(height: 8),
          keyVal13400('Tahun Produksi', data['tahunProduksi']),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget agunanData(List<dynamic> data) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle2(
                text: 'Jenis Kendaraan',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((val) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Subtitle2(text: val['jenisKendaraan']),
                  );
                }).toList(),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle2(
                text: 'Jumlah',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((val) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Subtitle2(text: val['jenisKendaraan'].toString()),
                  );
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget section3Widget(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3(text: 'Informasi Pinjaman'),
          const SizedBox(height: 10),
          const Headline3500(text: 'Pencairan'),
          const SizedBox(height: 8),
          keyVal13400(
              'Pokok Pinjaman', rupiahFormat(data['pokokPinjaman']).toString()),
          const SizedBox(height: 8),
          keyVal13400('Biaya Administrasi',
              rupiahFormat(data['biayaAdmin']).toString()),
          const SizedBox(height: 8),
          keyVal13400(
              'Biaya Asuransi', rupiahFormat(data['biayaAsuransi']).toString()),
          const SizedBox(height: 8),
          keyVal13400(
              'Biaya Fiducia', rupiahFormat(data['biayaFiducia']).toString()),
          const SizedBox(height: 8),
          keyVal13400('Promo', rupiahFormat(data['promo']).toString()),
          const SizedBox(height: 16),
          dividerDashed(context),
          const SizedBox(height: 16),
          keyVal13400('Total Pencairan',
              rupiahFormat(data['totalPencairan']).toString()),
          dividerFull2(context),
        ],
      ),
    );
  }

  Widget section3AngsuranWidget(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Info Angsuran'),
          const SizedBox(height: 8),
          keyVal13400('Jangka Waktu Angsuran', "${data['jangkaWaktu']} Bulan"),
          const SizedBox(height: 8),
          keyVal13400('Bunga Pinjaman Bulanan',
              rupiahFormat(data['bungaPinjaman']).toString()),
          const SizedBox(height: 8),
          keyVal13400('Fee Jasa Mitra Bulanan',
              rupiahFormat(data['feeJasaMitra']).toString()),
          const SizedBox(height: 16),
          dividerDashed(context),
          const SizedBox(height: 16),
          keyVal13400('Total Angsuran Bulanan',
              rupiahFormat(data['totalAngsuranBulanan']).toString()),
          dividerFull2(context),
        ],
      ),
    );
  }

  Widget section3PelunasanWidget(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Pelunasan Akhir'),
          const SizedBox(height: 8),
          keyVal13400(
              'Pokok Pinjaman', rupiahFormat(data['pokokPinjaman']).toString()),
          const SizedBox(height: 8),
          keyVal13400(
              'Bunga Pinjaman', rupiahFormat(data['bungaPinjaman']).toString()),
          const SizedBox(height: 8),
          keyVal13400(
              'Fee Jasa Mitra', rupiahFormat(data['feeJasaMitra']).toString()),
          const SizedBox(height: 16),
          dividerDashed(context),
          const SizedBox(height: 16),
          keyVal13400('Total Pelunasan Akhir',
              rupiahFormat(data['totalPelunasan']).toString()),
        ],
      ),
    );
  }

  Widget section4Widget(Map<String, dynamic> dataBank) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline4(text: 'Rekening Pencairan Dana'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: HexColor('#DDDDDD'), width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Subtitle1(text: dataBank['namaBank']),
                Row(
                  children: [
                    Subtitle2(text: maskCreditCard(dataBank['noRek'])),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        Navigator.popAndPushNamed(
                          context,
                          InfoBankPage.routeName,
                          arguments: InfoBankPage(),
                        );
                        // Add your onTap functionality here
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SyaratKetentuan extends StatefulWidget {
  final KonfirmasiPinjamanBloc2 bloc;
  const SyaratKetentuan({
    super.key,
    required this.bloc,
  });

  @override
  State<SyaratKetentuan> createState() => _SyaratKetentuanState();
}

class _SyaratKetentuanState extends State<SyaratKetentuan> {
  late final WebViewController webController;
  bool isCheck = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        widget.bloc.stepControl(1);
      }),
      backgroundColor: Colors.white,
      body: StreamBuilder<dynamic>(
        stream: widget.bloc.documentPerjanjian,
        builder: (context, snapshot) {
          print('data showing ${snapshot.data}');
          if (snapshot.hasData) {
            final data = snapshot.data;
            final dataEdit = data.replaceAll('http:', 'https:');
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: MediaQuery.of(context).size.height - 100,
              child: Transform(
                transform: Matrix4.identity()..scale(1.0),
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadHtmlString(
                      dataEdit,
                    )
                    ..enableZoom(true),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Subtitle2(text: snapshot.error.toString()),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: MediaQuery.of(context).size.height - 100,
            child: Transform(
              transform: Matrix4.identity()..scale(1.2),
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadHtmlString('data kosong')
                  ..enableZoom(true),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isCheck = !isCheck;
                });
              },
              child: checkBoxBorrower(
                isCheck,
                Wrap(
                  children: [
                    Subtitle2(
                      text: 'Saya telah membaca dan menyetujui Dokumen ',
                      color: HexColor('#777777'),
                    ),
                    const Subtitle2(
                      text: 'Perjanjian Pinjaman',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Button1(
              btntext: 'Setuju',
              color: isCheck ? null : Colors.grey,
              action: isCheck
                  ? () {
                      widget.bloc.checkPinjamanControl(true);
                      widget.bloc.stepControl(1);
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
