import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/dokumen/html/dokumen_bloc.page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DokumenHtmlPage extends StatefulWidget {
  static const routeName = '/dokumen_html_page';
  final String link;
  final String title;
  final Map<String, dynamic> param;
  const DokumenHtmlPage({
    super.key,
    this.title = 'Detail Dokumen',
    required this.link,
    this.param = const {},
  });

  @override
  State<DokumenHtmlPage> createState() => _DokumenHtmlPageState();
}

class _DokumenHtmlPageState extends State<DokumenHtmlPage> {
  @override
  void initState() {
    super.initState();
    context.bloc<DokumenBloc>().getDokumen(
          url: widget.link,
          param: widget.param,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<DokumenBloc>();
    return Scaffold(
      appBar: previousTitle(
        context,
        widget.title,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: StreamBuilder<String?>(
          stream: bloc.dokumen,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: TextWidget(
                  text: snapshot.error.toString(),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  align: TextAlign.center,
                ),
              );
            }
            if (snapshot.hasData) {
              final data = snapshot.data ?? '';
              final dataEdit = data.replaceAll('http:', 'https:');
              return WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadHtmlString(dataEdit)
                  ..setBackgroundColor(Colors.white)
                  ..enableZoom(true),
              );
            }
            return const Center(
              child: Column(
                children: [
                  SpacerV(value: 100),
                  CircularProgressIndicator(),
                  SpacerV(value: 8),
                  TextWidget(
                    text: 'Mohon Menunggu',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
