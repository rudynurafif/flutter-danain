// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StepAmbilEmas extends StatefulWidget {
  final CicilanDetailBloc cicilBloc;
  const StepAmbilEmas({
    super.key,
    required this.cicilBloc,
  });

  @override
  State<StepAmbilEmas> createState() => _StepAmbilEmasState();
}

class _StepAmbilEmasState extends State<StepAmbilEmas> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.cicilBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Ambil Emas', () {
        bloc.stepChange(1);
      }),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            final dataPelunasan = data['dataPelunasan'];
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/home/mitra.svg',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            Subtitle3(
                              text: 'Lokasi Pengambilan Emas',
                              color: HexColor('#777777'),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Headline3500(text: data['mitraPengambilan'] ?? ''),
                        const SizedBox(height: 8),
                        Subtitle2(
                          text: data['alamatMitraPengambilan'] ?? '',
                          color: HexColor('#777777'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 30,
                              child: Button2(
                                btntext: 'Hubungi Kami',
                                textcolor: Colors.white,
                                action: () async {
                                  final url = dataPelunasan['WACS'];
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    context.showSnackBarError(
                                      'Maaf sepertinya terjadi kesalahan',
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 30,
                              child: Button2(
                                btntext: 'Maps',
                                color: Colors.white,
                                textcolor: HexColor(primaryColorHex),
                                action: () async {
                                  final url = data['mapsPengambilan'];
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    context.showSnackBarError(
                                      'Maaf sepertinya terjadi kesalahan',
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  dividerFull(context),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Headline2500(text: 'QR Code'),
                        const SizedBox(height: 8),
                        Subtitle2(
                          text:
                              'Silakan datang ke lokasi mitra tempat  pengambilan emas dan tunjukkan QR code untuk pengambilan emas Anda.',
                          color: HexColor('#777777'),
                        ),
                        const SizedBox(height: 16),
                        qrCode(
                            dataPelunasan['QRPelunasan'], data['namaBorrower'])
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget qrCode(String? value, String? borrower) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: [
          BoxShadow(
            color: HexColor('#EEF4EE'),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Headline3500(text: borrower ?? 'User'),
          const SizedBox(height: 4),
          Subtitle2(
            text: value ?? 'value',
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 24),
          QrImageView(
            data: value ?? 'Kosong bro',
            embeddedImage:
                const AssetImage('assets/images/logo/logo_splash.png'),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(40, 40),
            ),
            size: 230,
            errorStateBuilder: (context, error) {
              return const Subtitle1(text: 'Maaf terjadi kesalahan');
            },
          )
        ],
      ),
    );
  }
}
