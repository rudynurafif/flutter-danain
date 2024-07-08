import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentStepPendanaan extends StatefulWidget {
  final PendanaanBloc pBloc;
  const DocumentStepPendanaan({super.key, required this.pBloc});

  @override
  State<DocumentStepPendanaan> createState() => _DocumentStepPendanaanState();
}

class _DocumentStepPendanaanState extends State<DocumentStepPendanaan> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    final bloc = widget.pBloc;
    return StreamBuilder<bool>(
      stream: bloc.isDetailStream,
      builder: (context, snapshot) {
        final isDetail = snapshot.data ?? false;
        return Scaffold(
            appBar: previousCustomWidget(context, () {
              if (isDetail == true) {
                bloc.stepControl(2);
              } else {
                bloc.stepControl(1);
              }
            }),
            body: StreamBuilder<dynamic>(
              stream: bloc.documentStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data ?? '';
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    margin: const EdgeInsets.only(bottom: 100),
                    height: MediaQuery.of(context).size.height - 170,
                    child: Transform(
                      transform: Matrix4.identity()..scale(1.2),
                      child: WebViewWidget(
                        controller: WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..loadHtmlString(
                            data.toString(),
                          )
                          ..enableZoom(true),
                      ),
                    ),
                  );
                }
                return Center(
                  child: Image.asset('assets/lender/loading/danain.png'),
                );
              },
            ),
            bottomNavigationBar: Container(
              height: 150,
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCheck = !isCheck;
                      });
                    },
                    child: checkBoxBorrower(
                      isCheck,
                      Wrap(
                        children: [
                          Subtitle2(
                            text: 'Saya telah membaca dan menyetujui Dokumen ',
                            color: HexColor('#777777'),
                          ),
                          const Subtitle2(
                            text: 'Perjanjian Pemberian Pinjaman',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Button1(
                    btntext: 'Setuju',
                    color: isCheck ? HexColor(lenderColor) : Colors.grey,
                    action: isCheck
                        ? () {
                            bloc.reqOtpSubmit();
                          }
                        : null,
                  )
                ],
              ),
            ));
      },
    );
  }
}
