import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/lokasi_penyimpanan_emas_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/modal/modalBottom.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../component/auxpage/search_location_2.dart';
import '../../../data/constants.dart';

class QrcodePages extends StatelessWidget {
  static const routeName = '/qrcode_pages';

  const QrcodePages({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController provinsiController = TextEditingController();
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? entryValue = arguments?['dataHome'].toString();
    final Map<String, dynamic>? user =
        arguments?['user'] as Map<String, dynamic>?;
    print('check user di qr $user');

    return Scaffold(
      appBar: previousTitleCustom(context, 'Pengajuan Pinjaman', () {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline2500(text: 'QR Code'),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Silakan datang ke mitra penyimpan emas (pergadaian) terdekat dan tunjukkan QR code untuk melanjutkan transaksi peminjaman.',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final PermissionStatus status =
                      await Permission.location.status;
                  if (status == PermissionStatus.granted) {
                    context.showSnackBarSuccess('Mohon Tunggu...');
                    checkLocationInfo(provinsiController, null, () {
                      Navigator.pushNamed(
                        context,
                        PenyimpananEmas.routeName,
                        arguments: PenyimpananEmas(
                          provinceName: provinsiController.text,
                        ),
                      );
                    });
                  } else {
                    await showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (ctx) => ModaLBottom(
                        image: 'assets/images/register/aktifkan_lokasi.svg',
                        title: locationActive,
                        subtitle: locationActiveSub,
                        action: SearchLocation2(
                          textButton: agreeText,
                          provinsi: provinsiController,
                          nextAction: () {
                            Navigator.popAndPushNamed(
                              context,
                              PenyimpananEmas.routeName,
                              arguments: PenyimpananEmas(
                                provinceName: provinsiController.text,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
                child: Subtitle2(
                  text: 'Lihat mitra terdekat >',
                  color: HexColor(primaryColorHex),
                ),
              ),
              const SizedBox(height: 24),
              qrCodeWidget(context, entryValue, user!),
            ],
          ),
        ),
      ),
    );
  }

  Widget qrCodeWidget(
      BuildContext context, String? entryValue, Map<String, dynamic> user) {
    final ktp = user['ktp'].toString();
    final email =
        user['email'].toString(); // Make sure 'data' is correctly defined
    entryValue ??= ''; // Set a default value for entryValue if it's null
    print('entry data $entryValue');
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
          Headline3500(text: email),
          const SizedBox(height: 4),
          Subtitle2(
            text: ktp,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 24),
          QrImageView(
            data: entryValue,
            embeddedImage:
                const AssetImage('assets/images/logo/logo_splash.png'),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(40, 40),
            ),
            size: 230,
          )
        ],
      ),
    );
  }
}
