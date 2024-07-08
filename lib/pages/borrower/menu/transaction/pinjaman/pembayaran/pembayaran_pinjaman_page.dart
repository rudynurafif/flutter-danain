import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_pinjaman_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PembayaranPinjamanPage extends StatefulWidget {
  static const routeName = '/detail_pembayaran_pinjaman';
  final Map<String, dynamic>? dataPinjaman;
  const PembayaranPinjamanPage({
    super.key,
    this.dataPinjaman,
  });

  @override
  State<PembayaranPinjamanPage> createState() => _PembayaranPinjamanPageState();
}

class _PembayaranPinjamanPageState extends State<PembayaranPinjamanPage> {
  Map<String, bool> expandedMap = {};

  bool expanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as PembayaranPinjamanPage?;
    if (args != null && args.dataPinjaman != null) {
      context.bloc<PembayaranPinjamanBloc>().detailPinjamanChange(
            args.dataPinjaman!,
          );
    }
  }

  @override
  void initState() {
    super.initState();
    context.bloc<PembayaranPinjamanBloc>().getMasterPembayaran();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PembayaranPinjamanBloc>(context);
    return Scaffold(
      appBar: previousTitle(context, 'Pembayaran'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.dataPinjamanStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? {};
                    final va = data['VA'];
                    final pembayaran = data['dataVa']['nominal'] ?? 0;
                    final expired = data['expiredAt'];
                    return Column(
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
                                'assets/images/logo/bank/bni.svg',
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Subtitle1(text: 'BNI'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        virtualAccount(va),
                        dividerFull2(context),
                        totalPembayaran(pembayaran),
                        const SizedBox(height: 54),
                        caraBayarWidget(bloc),
                        const SizedBox(height: 32),
                        Button1(
                          btntext: 'Kembali',
                          action: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return loadingWidget(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLong(
          height: 24,
          width: MediaQuery.of(context).size.width / 2,
        ),
        const SizedBox(height: 8),
        ShimmerLong(
          height: 36,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 16),
        const ShimmerLong4(height: 42, width: 74),
        const SizedBox(height: 16),
        ShimmerLong(
          height: 17,
          width: MediaQuery.of(context).size.width / 3,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerLong(
              height: 24,
              width: MediaQuery.of(context).size.width / 2.5,
            ),
            const ShimmerLong4(height: 18, width: 54),
          ],
        ),
        dividerFull2(context),
        ShimmerLong(
          height: 17,
          width: MediaQuery.of(context).size.width / 3,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerLong(
              height: 24,
              width: MediaQuery.of(context).size.width / 2.5,
            ),
            const ShimmerLong4(height: 18, width: 54),
          ],
        ),
      ],
    );
  }

  Widget subtitle(expired) {
    return Text.rich(
      TextSpan(children: <TextSpan>[
        const TextSpan(
          text: 'Segera selesaikan pembayaran sebelum ',
          style: TextStyle(
            color: Color(0xff777777),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: formatDateFull(expired),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
      textAlign: TextAlign.start,
    );
  }

  Widget virtualAccount(String va) {
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

  Widget totalPembayaran(num pembayaran) {
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
                    transform:
                        Matrix4.rotationY(180 * 3.1415926535897932 / 180),
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

  Widget caraBayarWidget(PembayaranPinjamanBloc detailPengajuanBloc) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Cara Pembayaran'),
          const SizedBox(height: 16),
          StreamBuilder<Map<String, dynamic>>(
            stream: detailPengajuanBloc.masterBankStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final List<Map<String, dynamic>> caraBayarDetailList =
                    data.entries.map((entry) {
                  return {entry.key: entry.value};
                }).toList();
                return caraBayarDetailWidget(caraBayarDetailList);
              }
              return caraBayarLoading(context);
            },
          )
        ],
      ),
    );
  }

  Widget caraBayarLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLong(
          height: 21,
          width: MediaQuery.of(context).size.width / 2,
        ),
        const SizedBox(height: 16),
        ShimmerLong(
          height: 24,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 16),
        ShimmerLong(
          height: 24,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 16),
        ShimmerLong(
          height: 24,
          width: MediaQuery.of(context).size.width,
        ),
      ],
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
