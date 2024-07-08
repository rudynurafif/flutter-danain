import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_PreviousTitle.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_cd_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_bloc2.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class KonfirmasiPinjamanCDDetail extends StatefulWidget {
  final KonfirmasiPincamanCdBloc ppBloc;
  const KonfirmasiPinjamanCDDetail({super.key, required this.ppBloc});

  @override
  State<KonfirmasiPinjamanCDDetail> createState() =>
      _KonfirmasiPinjamanCDDetailState();
}

class _KonfirmasiPinjamanCDDetailState
    extends State<KonfirmasiPinjamanCDDetail> {
  @override
  void initState() {
    super.initState();
  }

  bool _expanded = false;
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
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  section1Widget(data),
                  dividerFull(context),
                  section2Widget(data['jaminans']['data']),
                  dividerFull(context),
                  section3Widget(data),
                  dividerFull(context),
                  section4Widget(data['data_bank']),
                  const SizedBox(height: 16),
                  agreeCheckBox(bloc),
                  const SizedBox(height: 24),
                  buttonAgree(bloc),
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

  Widget agreeCheckBox(KonfirmasiPincamanCdBloc bloc) {
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

  Widget buttonAgree(KonfirmasiPincamanCdBloc bloc) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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

  Widget section1Widget(Map<String, dynamic> data) {
    final Map<String, dynamic> branch = data['jaminans'];
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Headline3500(text: branch['nama_branch']),
          const SizedBox(height: 8),
          Subtitle2(
            text: branch['alamat'],
            color: HexColor('777777'),
          )
        ],
      ),
    );
  }

  Widget section2Widget(List<dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Headline3500(text: 'Agunan'),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey,
                  size: 24,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Transform(
              transform: Matrix4.translationValues(0, _expanded ? 0 : 1, 0),
              child: agunanData(data),
            ),
            secondChild: const SizedBox.shrink(),
          ),
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
                text: 'Barang',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((val) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Subtitle2(text: val['nama_jaminan']),
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
                text: 'Berat/Karat',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((val) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child:
                        Subtitle2(text: '${val['gram']} gr/${val['karat']} k'),
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
                    child: Subtitle2(text: val['jumlahJaminan'].toString()),
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
    final dataJaminan = data['jaminans'];
    final dataPinjaman = data['pinjamans'];
    print('data pinjaman $dataPinjaman');
    final double jasaMitra = dataPinjaman['jasa_mitra_harian'].toDouble();
    final double biayaAdmin = dataPinjaman['biaya_admin'].toDouble();
    final double totalPencairan = dataPinjaman['total_pencairan'].toDouble();
    print('list data pinjaman $dataPinjaman');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Pinjaman'),
          const SizedBox(height: 8),
          keyVal('Jenis Pinjaman', dataJaminan['nama_produk']),
          const SizedBox(height: 8),
          keyVal('Tenor', '${dataPinjaman['tenor']} hari'),
          const SizedBox(height: 8),
          keyVal('Bunga Harian', rupiahFormat(dataPinjaman['bunga_harian'])),
          const SizedBox(height: 8),
          keyVal('Fee Jasa Mitra Harian', rupiahFormat(jasaMitra.toInt())),
          dividerFull2(context),
          keyVal('Pinjaman', rupiahFormat(dataPinjaman['pinjaman'])),
          const SizedBox(height: 8),
          keyVal('Biaya Administrasi', rupiahFormat(biayaAdmin.toInt())),
          const SizedBox(height: 16),
          dividerDashed(context),
          const SizedBox(height: 16),
          keyVal2('Total Pencairan', rupiahFormat(totalPencairan.toInt()))
        ],
      ),
    );
  }

  Widget section4Widget(Map<String, dynamic> dataBank) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: HexColor('#DDDDDD'), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Subtitle1(text: dataBank['nama_bank']),
            Row(
              children: [
                Subtitle2(text: maskCreditCard(dataBank['no_rekening'])),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 16,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SyaratKetentuan extends StatefulWidget {
  final KonfirmasiPincamanCdBloc bloc;
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
          if (snapshot.hasData) {
            final data = snapshot.data;
            print('data showing $data');
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: const EdgeInsets.only(bottom: 100),
              height: MediaQuery.of(context).size.height - 170,
              child: Transform(
                transform: Matrix4.identity()..scale(1.2),
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadHtmlString(
                      data.toString(),
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
          return Center(
            child: Image.asset('assets/images/icons/loading_danain.png'),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
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
