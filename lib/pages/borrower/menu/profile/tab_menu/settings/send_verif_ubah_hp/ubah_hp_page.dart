import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/step/step_1.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/step/step_2.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/ubah_hp_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class UbahHpPage extends StatefulWidget {
  static const routeName = '/ubah_hp';
  const UbahHpPage({super.key});

  @override
  State<UbahHpPage> createState() => _UbahHpPageState();
}

class _UbahHpPageState extends State<UbahHpPage> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
    final hpBloc = BlocProvider.of<UbahHpBloc>(context);
    return StreamBuilder<Result<AuthenticationState>?>(
      stream: hpBloc.authState,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return SizedBox(
            child: data?.fold(
              ifLeft: (value) {
                return bodyError();
              },
              ifRight: (value) {
                return bodyGas(value.userAndToken!, hpBloc);
              },
            ),
          );
        } else {
          return Container(
            color: Colors.yellow,
          );
        }
      },
    );
  }

  Widget bodyError() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: const Subtitle1(text: 'Maaf sepertinya terjadi kesalahan'),
    );
  }

  Widget bodyGas(UserAndToken userToken, UbahHpBloc hpBloc) {
    final Map<String, dynamic> beranda = JwtDecoder.decode(userToken.beranda);

    if (beranda['beranda']['status']['status_request_hp'] == 'waiting' ) {
      return bodyWaiting(userToken.user.tlpmobile, beranda);
    }
    return StreamBuilder<int>(
      stream: hpBloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        switch (data) {
          case 1:
            return Step1VerifHp(
              hpBloc: hpBloc,
              hisEmail: userToken.user.email,
            );
          case 2:
            return Step2VerifHp(hpBloc: hpBloc);
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget bodyWaiting(String hpLama, Map<String, dynamic> beranda) {
    print('beranda 123 body waiting ${beranda['beranda']['requestHp']}');
    final fotoSelfie =beranda['beranda']['requestHp']['foto_selfie'];
   rxPrefs.setString('gambar_change_hp', fotoSelfie);
    final hpNew =beranda['beranda']['requestHp']['new_hp'];
    final TextEditingController hpLamaController =
        TextEditingController(text: hpLama);
    final TextEditingController hpBaruController = TextEditingController(text: hpNew);

    return FutureBuilder<String?>(
      future: rxPrefs.getString('hp_baru'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          hpBaruController.text = snapshot.data!;
        }
        return Scaffold(
          appBar: previousTitle(context, 'Ubah Nomor Handphone'),
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
                        text: 'Nomor Handphone Lama',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        color: HexColor('#F5F6F7'),
                        child: AbsorbPointer(
                          child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: HexColor('#999999')),
                            decoration:
                                inputDecorNoError(context, 'No Hp Lama'),
                            controller: hpLamaController,
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
                        text: 'Nomor Handphone Baru',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        color: HexColor('#F5F6F7'),
                        child: AbsorbPointer(
                          child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: HexColor('#999999')),
                            decoration:
                                inputDecorNoError(context, 'No Hp Baru'),
                            controller: hpBaruController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<String?>(
                    future: rxPrefs.getString('gambar_change_hp'),
                    builder: (context, snapshot) {
                      print('foto selfie ${snapshot.data}');
                      if (snapshot.hasData) {
                        return Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(),
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image:  DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    alignment: FractionalOffset.center,
                                    image: NetworkImage(
                                    (snapshot.data).toString(),
                                    )),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget annoutcement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xffFDE8CF),
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
