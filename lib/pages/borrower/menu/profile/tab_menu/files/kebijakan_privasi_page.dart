import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';

class KebijakanPrivasiPage extends StatefulWidget {
  static const routeName = '/kebijakan_privasi';
  const KebijakanPrivasiPage({
    super.key,
  });

  @override
  State<KebijakanPrivasiPage> createState() => _KebijakanPrivasiPageState();
}

class _KebijakanPrivasiPageState extends State<KebijakanPrivasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Kebijakan Privasi'),
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
          'assets/files/kebijakan_privasi.pdf',
        ),
      ),
    );
  }
}
