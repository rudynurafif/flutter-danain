import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PembayaranPage extends StatefulWidget {
  static const routeName = '/pembayaran_pinjaman';
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  String va = '90234082125899273';
  int total = 42500;
  Map<String, bool> expandedMap = {};
  List<String> caraBayar = [
    'Masukan kartu ATM, lalu masukan PIN',
    'Pilih Menu “Menu Lainnya”',
    'Pilih Menu “Transfer”',
    'Pilih “Virtual Account Biling”',
    'Masukkan virtual account'
  ];

  bool expanded = false;
  @override
  void initState() {
    super.initState();

    // Delay the code execution to ensure initState has completed
    Future.delayed(Duration(seconds: 1), () {
      final detailPengajuanBloc = BlocProvider.of<PembayaranBloc>(context);
      detailPengajuanBloc.getMasterPembayaran();
      final dynamic argument = ModalRoute.of(context)!.settings.arguments;
      detailPengajuanBloc.idAggrementChange(argument);
      detailPengajuanBloc.detailPinjamanChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailPengajuanBloc = BlocProvider.of<PembayaranBloc>(context);
    return Scaffold(
      appBar: previousTitle(context, 'Pembayaran'),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: detailPengajuanBloc.detailPembayaram$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Handle the case where data is still loading or not available
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print('check data ${snapshot.data}');
            Map<String, dynamic> data = snapshot.data!;
            final va = data['data']['VA'];
            final pembayaran = data['data']['dataVa']['nominal'];
            final expired = data['data']['expiredAt'];

            return Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Headline2500(text: 'Pembayaran Pinjaman'),
                    const SizedBox(height: 8),
                    subtitle(expired),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: HexColor('#F5F6F7'),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                              'assets/images/logo/bank/bni.svg'),
                        ),
                        const SizedBox(width: 4),
                        const Subtitle1(text: 'BNI'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    virtualAccount(detailPengajuanBloc, va),
                    dividerFull2(context),
                    totalPembayaran(detailPengajuanBloc, pembayaran),
                    const SizedBox(height: 54),
                    caraBayarWidget(detailPengajuanBloc),
                    const SizedBox(height: 32),
                    Button1(
                      btntext: 'Kembali',
                      action: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget subtitle(expired) {
    return Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
          text: 'Segera selesaikan pembayaran sebelum ',
          style: TextStyle(
            color: Color(0xff777777),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: formatDateFull(expired),
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
      textAlign: TextAlign.start,
    );
  }

  Widget virtualAccount(PembayaranBloc detailPengajuanBloc, va) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(
          text: 'No. Virtual Account',
          color: HexColor('#AAAAAA'),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Headline2500(text: va),
            GestureDetector(
              onTap: () {
                BuildContext? dialogContext;
                Clipboard.setData(ClipboardData(text: va));
                showDialog(
                  context: context,
                  builder: (context) {
                    dialogContext = context;
                    return const AlertDialog(
                      backgroundColor: Colors.white,
                      content: Subtitle2(
                        text: 'No.Virtual Account berhasil disalin',
                        align: TextAlign.center,
                      ),
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    );
                  },
                );
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    if (dialogContext != null) {
                      Navigator.of(dialogContext!).pop();
                    }
                  },
                );
              },
              child: Row(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(
                      180 * 3.1415926535897932 / 180,
                    ), // 180 degrees in radians
                    child: Icon(
                      Icons.content_copy,
                      color: HexColor('#288C50'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Subtitle2Extra(
                    text: 'Salin',
                    color: HexColor('#288C50'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget totalPembayaran(PembayaranBloc detailPengajuanBloc, pembayaran) {
    // Replace this with the actual property from your stream

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(text: 'Total Pembayaran', color: HexColor('#AAAAAA')),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Headline2500(text: rupiahFormat(pembayaran)),
            GestureDetector(
              onTap: () {
                BuildContext? dialogContext;
                Clipboard.setData(ClipboardData(text: pembayaran.toString()));
                showDialog(
                  context: context,
                  builder: (context) {
                    dialogContext = context;
                    return const AlertDialog(
                      backgroundColor: Colors.white,
                      content: Subtitle2(
                        text: 'Total pembayaran berhasil disalin',
                        align: TextAlign.center,
                      ),
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    );
                  },
                );
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    if (dialogContext != null) {
                      Navigator.of(dialogContext!).pop();
                    }
                  },
                );
              },
              child: Row(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(180 *
                        3.1415926535897932 /
                        180), // 180 degrees in radians
                    child: Icon(
                      Icons.content_copy,
                      color: HexColor('#288C50'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Subtitle2Extra(
                    text: 'Salin',
                    color: HexColor('#288C50'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget caraBayarWidget(PembayaranBloc detailPengajuanBloc) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Cara Pembayaran'),
          const SizedBox(height: 16),
          StreamBuilder<Map<String, dynamic>>(
            stream: detailPengajuanBloc.masterPembayaran$,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final List<Map<String, dynamic>> caraBayarDetailList =
                    data.entries.map((entry) {
                  return {entry.key: entry.value};
                }).toList();
                return caraBayarDetailWidget(caraBayarDetailList);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget caraBayarDetailWidget(List<Map<String, dynamic>> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final methodName = entry.value.keys.first;
        final methodList = entry.value[methodName];
        bool expanded = expandedMap[methodName] ?? false;

        return Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  expanded = !expanded;
                  expandedMap[methodName] = expanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Subtitle2(
                    text: methodName,
                    color: HexColor('#333333'),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
            if (expanded)
              Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.translationValues(0, expanded ? 0 : 1, 0),
                child: caraBayarDetail(context, methodList),
              ),
            if (index != data.length - 1)
              Column(
                children: [
                  const SizedBox(height: 16),
                  dividerFullNoPadding(context),
                  const SizedBox(height: 16),
                ],
              )
          ],
        );
      }).toList(),
    );
  }
}
