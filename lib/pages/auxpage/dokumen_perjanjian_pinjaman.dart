import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DokumenPerjanjianPinjaman extends StatefulWidget {
  static const routeName = '/dokumen_perjanjian_pinjaman';

  const DokumenPerjanjianPinjaman({Key? key}) : super(key: key);

  @override
  State<DokumenPerjanjianPinjaman> createState() =>
      _DokumenPerjanjianPinjamanState();
}

class _DokumenPerjanjianPinjamanState extends State<DokumenPerjanjianPinjaman> {
  @override
  Widget build(BuildContext context) {
    final pdfData = ModalRoute.of(context)?.settings.arguments as String?;
    print('link data pdf dokumen  $pdfData');

    Widget bodyWidget;

    if (pdfData != null && pdfData.toLowerCase().startsWith('http://')) {
      bodyWidget = PDF(
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
        pdfData,
      );
    } else {
      bodyWidget = Transform(
        transform: Matrix4.identity()..scale(1.0),
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadHtmlString(
              pdfData!,
            )
            ..enableZoom(true),
        ),
      );
    }

    return Scaffold(
      appBar: previousTitle(context, 'Detail Dokumen'),
      backgroundColor: HexColor('#FFFFFF'),
      body: bodyWidget,
    );
  }
}
