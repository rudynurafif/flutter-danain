import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class HaveUbahEmail extends StatefulWidget {
  final UserAndToken userToken;
  const HaveUbahEmail({super.key, required this.userToken});

  @override
  State<HaveUbahEmail> createState() => _HaveUbahEmailState();
}

class _HaveUbahEmailState extends State<HaveUbahEmail> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : RxSharedPreferencesDefaultLogger(),
  );
  TextEditingController emailLamaController = TextEditingController();
  TextEditingController emailBaruController = TextEditingController();
  String image = 'https://image.com';

  @override
  void initState() {
    super.initState();
    final beranda = widget.userToken.beranda;
    final data = JwtDecoder.decode(beranda);
    // print(data['beranda']['status_request_hp']);
    emailLamaController.text = data['beranda']['requestEmail']['oldEmail'];
    emailBaruController.text = data['beranda']['requestEmail']['newEmail'];
    setState(() {
      image = data['beranda']['requestEmail']['foto_selfie'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Ubah Alamat Email'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              annoutcement(context),
              const SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Alamat Email Lama',
                    color: HexColor('#AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    color: HexColor('#F5F6F7'),
                    child: AbsorbPointer(
                      child: TextFormField(
                        style: TextStyle(color: HexColor('#999999')),
                        decoration: inputDecorNoError(context, 'Alamat Lama'),
                        controller: emailLamaController,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Alamat Email Baru',
                    color: HexColor('#AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    color: HexColor('#F5F6F7'),
                    child: AbsorbPointer(
                      child: TextFormField(
                        style: TextStyle(color: HexColor('#999999')),
                        decoration:
                            inputDecorNoError(context, 'Alamat Email Baru'),
                        controller: emailBaruController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  image,
                  width: MediaQuery.of(context).size.width,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child:
                          Subtitle2(text: 'Maaf sepertinya terjadi kesalahan'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget annoutcement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xffFFF5F2),
          borderRadius: BorderRadius.circular(8)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 16, color: Colors.orange),
          SizedBox(width: 8),
          Flexible(
            child: Subtitle3(
              text:
                  'Saat ini perubahan nomor handphone sedang dalam verifikasi. Proses verifikasi memerlukan waktu kurang lebih 1x24 jam',
              color: Color(0xff777777),
              align: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}
