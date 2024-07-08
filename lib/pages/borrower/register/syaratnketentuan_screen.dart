import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class SyaratnKetentuanPage extends StatefulWidget {
  final RegisterBloc rgBloc;
  const SyaratnKetentuanPage({
    super.key,
    required this.rgBloc,
  });

  @override
  State<SyaratnKetentuanPage> createState() => _SyaratnKetentuanPageState();
}

class _SyaratnKetentuanPageState extends State<SyaratnKetentuanPage> {
  bool toLast = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.rgBloc.haveAgreeStream,
      builder: (context, snapshot) {
        final isAgree = snapshot.data ?? false;
        return Scaffold(
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
              ? agreeButton(context, widget.rgBloc)
              : toLast == false
                  ? scrollDirection(context)
                  : agreeButton(context, widget.rgBloc),
        );
      },
    );
  }
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

Widget agreeButton(BuildContext context, RegisterBloc rgBloc) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(24),
        child: Button1(
          btntext: agreeText,
          action: () {
            rgBloc.changeAgree(true);
            rgBloc.stepController.add(0);
          },
        ),
      ),
    ],
  );
}
