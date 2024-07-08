import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class DokumenPdfPage extends StatefulWidget {
  static const routeName = '/dokumen_page ';
  final String title;
  final String link;
  const DokumenPdfPage({
    super.key,
    this.title = 'Detail Dokumen',
    required this.link,
  });

  @override
  State<DokumenPdfPage> createState() => _DokumenPdfPageState();
}

class _DokumenPdfPageState extends State<DokumenPdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(
        context,
        widget.title,
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
        ).fromUrl(
          widget.link,
        ),
      ),
    );
  }
}
