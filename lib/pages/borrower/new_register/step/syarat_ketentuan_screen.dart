import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/template/app_bar.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';

class SyaratKetentuanScreen extends StatefulWidget {
  const SyaratKetentuanScreen({super.key});

  @override
  State<SyaratKetentuanScreen> createState() => _SyaratKetentuanScreenState();
}

class _SyaratKetentuanScreenState extends State<SyaratKetentuanScreen> {
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        isLeading: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
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
          onPageChanged: (page, total) {
            if ((page! + 1) == total) {
              setState(() {
                isLast = true;
              });
            } else {
              setState(() {
                isLast = false;
              });
            }
          },
        ).fromAsset(
          'assets/files/syarat_ketentuan.pdf',
        ),
      ),
      bottomNavigationBar: bottom(isLast),
    );
  }

  Widget bottom(bool isValid) {
    if (isValid == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: ButtonWidget(
              title: 'Setuju',
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      );
    }
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(24),
          child: TextWidget(
            text: 'Scroll ke bawah untuk menyetujui',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
