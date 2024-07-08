import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
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

  List<String> caraBayar = [
    'Masukan kartu ATM, lalu masukan PIN',
    'Pilih Menu “Menu Lainnya”',
    'Pilih Menu “Transfer”',
    'Pilih “Virtual Account Biling”',
    'Masukkan virtual account'
  ];

  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Pembayaran'),
      body: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline2500(text: 'Pembayaran Pinjaman'),
              const SizedBox(height: 8),
              subtitle(),
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
                        borderRadius: BorderRadius.circular(8)),
                    child: SvgPicture.asset('assets/images/logo/bank/bni.svg'),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Subtitle1(text: 'BNI')
                ],
              ),
              const SizedBox(height: 16),
              virtualAccount(),
              dividerFull2(context),
              totalPembayaran(),
              const SizedBox(height: 54),
              caraBayarWidget(),
              const SizedBox(height: 32),
              Button1(
                btntext: 'Kembali',
                action: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget subtitle() {
    return const Text.rich(
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
          text: ' Jumat, 26 November 2022  23:59 WIB',
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

  Widget virtualAccount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Subtitle3(text: 'No. Virtual Account'),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Headline2500(text: va),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: va));
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
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
                  ),
                );
                Future.delayed(
                    const Duration(seconds: 1), () => Navigator.pop(context));
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
                      color: HexColor(primaryColorHex),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Subtitle2Extra(text: 'Salin')
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget totalPembayaran() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Subtitle3(text: 'Total Pembayaran'),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Headline2500(text: rupiahFormat(total)),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: total.toString()));
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    backgroundColor: Colors.white,
                    content: Subtitle2(
                      text: 'Total Pembayaran berhasil disalin',
                      align: TextAlign.center,
                    ),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                );
                Future.delayed(
                  const Duration(seconds: 1),
                  () => Navigator.pop(context),
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
                      color: HexColor(primaryColorHex),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Subtitle2Extra(text: 'Salin')
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget caraBayarWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Cara Pembayaran'),
          const SizedBox(height: 16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Subtitle2(
                    text: 'ATM BNI',
                    color: HexColor('#333333'),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Transform(
              transform: Matrix4.translationValues(0, _expanded ? 0 : 1, 0),
              child: caraBayarDetail(context, caraBayar),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
