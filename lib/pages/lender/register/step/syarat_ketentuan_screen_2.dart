import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../widgets/widget_element.dart';

class SyaratDanKetentuanLender extends StatefulWidget {
  final RegisterLenderBloc bloc;
  const SyaratDanKetentuanLender({super.key, required this.bloc});

  @override
  State<SyaratDanKetentuanLender> createState() =>
      _SyaratDanKetentuanLenderState();
}

class _SyaratDanKetentuanLenderState extends State<SyaratDanKetentuanLender> {
  bool toLast = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bloc.haveAgreeStream,
      builder: (context, snapshot) {
        final isAgree = snapshot.data ?? false;
        return Scaffold(
          appBar: previousCustomWidget(context, () {
            widget.bloc.stepControl(1);
          }),
          backgroundColor: Colors.white,
          body: PDF(
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: false,
            onError: (error) {
              print(error.toString());
            },
            onPageChanged: ((page, total) {
              print('page bang $page');
              print('total bang: $total');
              setState(() {
                if ((page! + 1) == total) {
                  toLast = true;
                } else {
                  toLast = false;
                }
              });
            }),
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
          ).fromAsset(
            'assets/files/syarat_ketentuan.pdf',
          ),
          bottomNavigationBar: isAgree == true
              ? agreeButton(context, widget.bloc)
              : toLast == false
                  ? scrollDirection(context)
                  : agreeButton(
                      context,
                      widget.bloc,
                    ),
        );
      },
    );
  }

  Widget scrollDirection(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(24),
          child: SubtitleExtra(
            text: scrollHint,
            align: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget agreeButton(BuildContext context, RegisterLenderBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Button1(
            color: HexColor(lenderColor),
            btntext: agreeText,
            action: () {
              bloc.checkControl(true);
              bloc.stepControl(1);
            },
          ),
        ),
      ],
    );
  }
}
