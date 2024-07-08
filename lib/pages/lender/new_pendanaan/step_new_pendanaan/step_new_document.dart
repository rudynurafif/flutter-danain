import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../data/constants.dart';
import '../../../../layout/appBar_previousTitle.dart';
import '../../../../widgets/widget_element.dart';
import '../new_detail_pendanaan/new_detail_pendanaan_bloc.dart';

class StepNewDokumen extends StatefulWidget {
  final NewDetailPendanaanBloc bloc;
  const StepNewDokumen({super.key, required this.bloc});

  @override
  State<StepNewDokumen> createState() => _StepNewDokumenState();
}

class _StepNewDokumenState extends State<StepNewDokumen> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;

    return Scaffold(
      appBar: previousTitle(context, ''),
      body: StreamBuilder<String?>(
        stream: bloc.documentStream,
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
            // return DokumenPdfPage(
            //   link: data,
            //   title: 'Perjanjian Pemberian Pinjmaman',
            // );
            return Container(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Transform(
                transform: Matrix4.identity()..scale(1.0),
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadHtmlString(dataEdit)
                    ..enableZoom(true),
                ),
              ),
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
                  widget.bloc.agreementPP(isCheck);
                });
              },
              child: checkBoxLender(
                isCheck,
                Expanded(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Saya telah membaca dan menyetujui ',
                        style: TextStyle(
                          color: HexColor('#777777'),
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Perjanjian Pemberian Pinjaman',
                        style: TextStyle(
                          color: HexColor('#333333'),
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Button1(
              btntext: 'Lanjut',
              color: isCheck ? HexColor(lenderColor) : HexColor('#ADB3BC'),
              action: isCheck
                  ? () {
                      Navigator.pop(context, true);
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
