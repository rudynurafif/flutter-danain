import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/registerNew/registerNew_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../widgets/widget_element.dart';

class SyaratDanKetentuanBorrower extends StatefulWidget {
  final RegisterNewBloc bloc;
  final bool haveAgree;
  const SyaratDanKetentuanBorrower(
      {super.key, required this.bloc, required this.haveAgree});

  @override
  State<SyaratDanKetentuanBorrower> createState() =>
      _SyaratDanKetentuanBorrowerState();
}

class _SyaratDanKetentuanBorrowerState
    extends State<SyaratDanKetentuanBorrower> {

  bool toLast = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: PDF(
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: false,
                  onError: (error) {
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                ).fromAsset(
                  'assets/files/syarat_ketentuan.pdf',
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: widget.haveAgree == true
            ? agreeButton(context, widget.bloc)
            : toLast == false
                ? scrollDirection(context)
                : agreeButton(context, widget.bloc),
      ),
    );
  }

  Widget scrollDirection(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(24),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: const Center(
        child: SubtitleExtra(
          text: scrollHint,
          align: TextAlign.center,
        ),
      ),
    );
  }

  Widget agreeButton(BuildContext context, RegisterNewBloc bloc) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Button1(
        color: HexColor(borrowerColor),
        btntext: agreeText,
        action: () {
          bloc.checkControl(true);
          Navigator.pop(context);
        },
      ),
    );
  }
}
