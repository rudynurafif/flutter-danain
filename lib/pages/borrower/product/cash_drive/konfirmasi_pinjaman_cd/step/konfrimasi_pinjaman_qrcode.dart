// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class KonfirmasiPinjamanQrCodePage extends StatefulWidget {
  final KonfirmasiPinjamanBloc2 ppBloc;
  const KonfirmasiPinjamanQrCodePage({
    super.key,
    required this.ppBloc,
  });

  @override
  State<KonfirmasiPinjamanQrCodePage> createState() =>
      _KonfirmasiPinjamanQrCodePage2State();
}

class _KonfirmasiPinjamanQrCodePage2State
    extends State<KonfirmasiPinjamanQrCodePage> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.ppBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Penyerahan BPKB', () {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      }),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: bloc.responseKonfirmasi,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            final dataMitra = data['mitra'];
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
                              text: 'Lokasi Penyerahan BPKB',
                              color: HexColor('#777777'),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Headline3500(
                            text: dataMitra['namaCabang'] ?? 'MAS MELAWAI'),
                        const SizedBox(height: 8),
                        Subtitle2(
                          text: dataMitra['alamatDetail'],
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
                              height: 32,
                              child: Button2(
                                btntext: 'Hubungi Kami',
                                textcolor: Colors.white,
                                action: () async {
                                  final url =
                                      dotenv.env['CALL_CENTER'].toString();
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
                              height: 32,
                              child: Button2(
                                btntext: 'Maps',
                                color: Colors.white,
                                textcolor: HexColor(primaryColorHex),
                                action: () async {
                                  final url =
                                      'http://maps.google.com/maps?q=${dataMitra['longitude']},${dataMitra['latitude']}';

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
                    child: StreamBuilder<int>(
                      stream: widget.ppBloc.isPenyerahanBpkbStream,
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Headline2500(text: 'QR Code'),
                            const SizedBox(height: 8),
                            Subtitle2(
                              text:
                                  'Silakan datang ke lokasi mitra dan tunjukkan QR code untuk penyerahan BPKB.',
                              color: HexColor('#777777'),
                            ),
                            const SizedBox(height: 24),
                            qrCode(
                              snapshot.data == 2 ? data['noKtp'] : data['QR'],
                              data['QR'],
                              data['namaBorrower'],
                            )
                          ],
                        );
                      },
                    ),
                  ),
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

  Widget qrCode(String? value, String? qr, String? borrower) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: HexColor('#FFFFFF'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
          qrCodeImage(qr ?? ''),
        ],
      ),
    );
  }

  Widget qrCodeImage(String valueQr) {
    if (valueQr == '') {
      return const Center(
        child: TextWidget(
          text: 'Qr code tidak tersedia',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    return QrImageView(
      data: valueQr,
      embeddedImage: const AssetImage('assets/images/logo/logo_splash.png'),
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size(40, 40),
      ),
      size: 230,
      errorStateBuilder: (context, error) {
        return const Subtitle1(text: 'Maaf terjadi kesalahan');
      },
    );
  }
}
