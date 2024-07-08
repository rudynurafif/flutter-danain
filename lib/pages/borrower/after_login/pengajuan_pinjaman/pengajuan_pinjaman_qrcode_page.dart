import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/pengajuan_pinjaman/pengajuan_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/lokasi_penyimpanan_emas_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/modal/modalBottom.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../../../component/auxpage/search_location_2.dart';

class PengajuanPinjamanPage2 extends StatelessWidget {
  final PengajuanPinjamanBloc ppBloc;
  const PengajuanPinjamanPage2({super.key, required this.ppBloc});

  @override
  Widget build(BuildContext context) {
    final TextEditingController provinsiController = TextEditingController();
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProfileData(), // Define a function to fetch profile data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // You can return a loading indicator if the data is still loading.
          return Center(
            child: Image.asset('assets/images/icons/loading_danain.png'),
          );
        } else if (snapshot.hasError) {
          // Handle any errors that occurred during data fetching.
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Data is available; you can use it in your widget.
          print('detail user ${snapshot.data}');
          final username = snapshot.data!['username'];
          final ktp = snapshot.data!['ktp'];

          return Scaffold(
            appBar: previousTitleCustom(context, 'Pengajuan Pinjaman', () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName, (Route<dynamic> route) => false);
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
                          'Silakan datang ke mitra peyimpan emas (pergadaian) terdekat dan tunjukkan QR code untuk melanjutkan transaksi peminjaman.',
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
                              image:
                                  'assets/images/register/aktifkan_lokasi.svg',
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
                    qrCodeWidget(ppBloc, username, ktp),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Handle the case where no data is available.
          return Text('No data available');
        }
      },
    );
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    final rxPrefs = RxSharedPreferences(
      SharedPreferences.getInstance(),
      kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
    );
    final username = await rxPrefs.getString('usernameProfile');
    final ktp = await rxPrefs.getString('ktpProfile');

    return {'username': username, 'ktp': ktp};
  }

  Widget qrCodeWidget(PengajuanPinjamanBloc bloc, username, ktp) {
    return StreamBuilder(
      stream: bloc.dataPinjamanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // PinjamanResponse data = snapshot.data!;
          final data = snapshot.data!;
          print('detail data pinjaman $data');
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              shadows: [
                BoxShadow(
                  color: HexColor('#EEF4EE'),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Headline3500(text: username.toString()),
                const SizedBox(height: 4),
                Subtitle2(text: ktp.toString(), color: HexColor('#777777')),
                SizedBox(height: 24),
                QrImageView(
                  data: data,
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
        } else {
          return Center(
            child: Image.asset('assets/images/icons/loading_danain.png'),
          );
        }
      },
    );
  }
}
