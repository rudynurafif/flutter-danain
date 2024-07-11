import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/detail_transaksi_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class StepBayarDetailTransaksi extends StatefulWidget {
  final DetailTransaksiBlocV3 transaksiBloc;
  final Map<String, dynamic> data;
  const StepBayarDetailTransaksi(
      {super.key, required this.transaksiBloc, required this.data});

  @override
  State<StepBayarDetailTransaksi> createState() =>
      _StepBayarDetailTransaksiState();
}

class _StepBayarDetailTransaksiState extends State<StepBayarDetailTransaksi> {
  @override
  void initState() {
    super.initState();
    widget.transaksiBloc.getMasterBank();
  }

  final Map<String, bool> _expandedMap = {};

  @override
  Widget build(BuildContext context) {
    final bloc = widget.transaksiBloc;
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.responseVa,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        } else {
          return Scaffold(
            appBar: previousTitleCustom(
              context,
              'Pembayaran',
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.routeName,
                (route) => false,
              ),
            ),
            body: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                      child: Headline2500(text: 'Pembayaran Angsuran Pertama'),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: subtitle(bloc),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/lender/bank/bni.svg'),
                          const SizedBox(width: 12),
                          const Subtitle2Extra(text: 'BNI')
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: virtualAccount(bloc),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: totalPembayaran(bloc),
                    ),
                    const SizedBox(height: 8),
                    dividerFull(context),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: caraBayarWidget(bloc),
                    ),
                    dividerFull(context),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Button1(
                        btntext: 'Kembali',
                        action: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomePage.routeName,
                            arguments: const HomePage(
                              index: 1,
                              subIndex: 1,
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget subtitle(DetailTransaksiBlocV3 bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.resultValidate,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
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
                text: formatDateFull(data['expiredAt']),
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
        // return const Center(
        //   child: CircularProgressIndicator(),
        // );
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
              text: formatDateFull(widget.data['tglJt']),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
          textAlign: TextAlign.start,
        );
      },
    );
  }

  Widget virtualAccount(DetailTransaksiBlocV3 bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.resultValidate,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
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
                  Headline2500(text: data['dataVa']['virtual_account']),
                  GestureDetector(
                    onTap: () {
                      BuildContext? dialogContext;
                      Clipboard.setData(ClipboardData(text: "19191919"));
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
                          transform:
                              Matrix4.rotationY(180 * 3.1415926535897932 / 180),
                          child: Icon(
                            Icons.content_copy,
                            color: HexColor(primaryColorHex),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Subtitle2Extra(
                          text: 'Salin',
                          color: HexColor(primaryColorHex),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              dividerFullNoPadding(context),
            ],
          );
        }

        // return const Center(
        //   child: LinearProgressIndicator(),
        // );
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
                Headline2500(text: widget.data['noVa'].toString()),
                GestureDetector(
                  onTap: () {
                    BuildContext? dialogContext;
                    Clipboard.setData(
                        ClipboardData(text: widget.data['noVa'].toString()));
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
                        transform:
                            Matrix4.rotationY(180 * 3.1415926535897932 / 180),
                        child: Icon(
                          Icons.content_copy,
                          color: HexColor(primaryColorHex),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Subtitle2Extra(
                        text: 'Salin',
                        color: HexColor(primaryColorHex),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            dividerFullNoPadding(context),
          ],
        );
      },
    );
  }

  Widget totalPembayaran(DetailTransaksiBlocV3 bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.resultValidate,
      builder: (context, snapshot) {
        final data = snapshot.data!;
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          // return const Center(
          //   child: LinearProgressIndicator(),
          // );
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle3(
                text: 'Total Pembayaran',
                color: HexColor('#AAAAAA'),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Headline2500(text: rupiahFormat(data['angsuran'])),
                  GestureDetector(
                    onTap: () {
                      BuildContext? dialogContext;
                      Clipboard.setData(ClipboardData(text: data['angsuran']));
                      showDialog(
                        context: context,
                        builder: (context) {
                          // r dialogContext = context;
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
                            color: HexColor(primaryColorHex),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Subtitle2Extra(
                          text: 'Salin',
                          color: HexColor(primaryColorHex),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final num total = data['angsuran'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle3(
                text: 'Total Pembayaran',
                color: HexColor('#AAAAAA'),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Headline2500(text: rupiahFormat(data['angsuran'])),
                  GestureDetector(
                    onTap: () {
                      BuildContext? dialogContext;
                      Clipboard.setData(
                          ClipboardData(text: total.toInt().toString()));
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
                            color: HexColor(primaryColorHex),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Subtitle2Extra(
                          text: 'Salin',
                          color: HexColor(primaryColorHex),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        }
        // return const Center(
        //   child: LinearProgressIndicator(),
        // );
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Total Pembayaran',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Headline2500(text: rupiahFormat(data['angsuran'])),
                GestureDetector(
                  onTap: () {
                    BuildContext? dialogContext;
                    Clipboard.setData(ClipboardData(text: data['angsuran']));
                    showDialog(
                      context: context,
                      builder: (context) {
                        // r dialogContext = context;
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
                          color: HexColor(primaryColorHex),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Subtitle2Extra(
                        text: 'Salin',
                        color: HexColor(primaryColorHex),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  Widget caraBayarWidget(DetailTransaksiBlocV3 bloc) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Cara Pembayaran'),
          const SizedBox(height: 16),
          StreamBuilder<Map<String, dynamic>>(
            stream: bloc.caraBayarStream,
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
        List<dynamic> steps = methodList.keys
            .where((step) => step != methodList)
            .map((step) => methodList[step]!)
            .toList();

        print('check list name $methodList');
        bool _expanded = _expandedMap[methodName] ?? false;

        return Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                  _expandedMap[methodName] = _expanded;
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
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
            if (_expanded)
              Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.translationValues(0, _expanded ? 0 : 1, 0),
                child: caraBayarDetail(context, steps),
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
