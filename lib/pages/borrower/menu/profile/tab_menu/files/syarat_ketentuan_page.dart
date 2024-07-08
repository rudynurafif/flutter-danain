import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class SyaratKetentuan extends StatefulWidget {
  static const routeName = '/syarat_ketentuan ';
  const SyaratKetentuan({super.key});

  @override
  State<SyaratKetentuan> createState() => _SyaratKetentuanState();
}

class _SyaratKetentuanState extends State<SyaratKetentuan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Syarat Dan Ketentuan'),
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
        ).fromAsset(
          'assets/files/syarat_ketentuan.pdf',
        ),
      ),
    );
  }
}
