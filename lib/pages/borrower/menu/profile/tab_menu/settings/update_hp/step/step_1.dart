import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class Step1UpdateHp extends StatefulWidget {
  final UpdateHpBloc hpBloc;
  const Step1UpdateHp({super.key, required this.hpBloc});

  @override
  State<Step1UpdateHp> createState() => _Step1UpdateHpState();
}

class _Step1UpdateHpState extends State<Step1UpdateHp> {
  TextEditingController hpLamacontroller = TextEditingController();
  TextEditingController hpBaruController = TextEditingController();

  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
    final bloc = widget.hpBloc;
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
              noHpLama(bloc),
              const SizedBox(height: 16),
              noHpBaruWidget(bloc),
              const SizedBox(height: 16),
              lastWidgetControl(bloc)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<bool>(
              stream: bloc.buttonReqOtp,
              builder: (context, snapshot) {
                final isValid = snapshot.data ?? false;
                return ButtonNormal(
                  btntext: 'Ajukan Perubahan',
                  color: isValid ? null : Colors.grey,
                  action: isValid
                      ? () {
                          showAlertNotification(bloc);
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAlertNotification(UpdateHpBloc hpBloc) {
    showDialog(
      context: context,
      builder: (context) => ModalPopUp(
        icon: 'assets/images/icons/edit_icon.svg',
        title: 'Pengajuan Perubahan No. Handphone',
        message:
            'Dengan melakukan perubahan nomor handphone, Anda tidak dapat melakukan pengajuan transaksi selama proses verifikasi data.',
        actions: [
          Button2(
            btntext: 'Ajukan Perubahan',
            action: () {
              hpBloc.submitOtp();
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),
          Center(
            child: InkWell(
              child: Subtitle2(
                text: 'Batal',
                color: HexColor(primaryColorHex),
              ),
              onTap: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  Widget noHpLama(UpdateHpBloc hpBloc) {
    return StreamBuilder<Result<AuthenticationState>>(
      stream: hpBloc.authState,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data!.map((value) {
            hpLamacontroller.text = value.userAndToken!.user.tlpmobile;
          });
        }
        return Column(
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
                  decoration: inputDecorNoError(context, 'No Hp Lama'),
                  controller: hpLamacontroller,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget noHpBaruWidget(UpdateHpBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.newHpError,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Nomor Handphone Baru',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black),
                  controller: hpBaruController,
                  decoration: inputDecor(
                    context,
                    'Contoh: 088xxxxxx',
                    snapshot.hasData,
                  ),
                  onChanged: bloc.newHpControl,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                if (snapshot.hasData)
                  Padding(
                    padding: const EdgeInsets.only(top: 66),
                    child: Subtitle2(
                      text: snapshot.data!,
                      color: Colors.red,
                    ),
                  )
              ],
            )
          ],
        );
      },
    );
  }

  Widget lastWidgetControl(UpdateHpBloc hpBloc) {
    return StreamBuilder<File>(
      stream: hpBloc.fileStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return selfie(hpBloc);
        } else {
          return ambilSelfie(hpBloc);
        }
      },
    );
  }

  Widget selfie(UpdateHpBloc hpBloc) {
    return StreamBuilder<File>(
      stream: hpBloc.fileStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.center,
                        image: FileImage(snapshot.data!),
                      ),
                    ),
                  ),
                ),
              ),
              ButtonSmall2(
                btntext: 'Ambil ulang foto',
                // color: Colors.transparent,
                action: () async {
                  final cameras = await availableCameras();
                  final firstCamera = cameras.firstWhere(
                    (camera) =>
                        camera.lensDirection == CameraLensDirection.front,
                    orElse: () => cameras.first,
                  );
                  final picturePath = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraWidget(
                        camera: firstCamera,
                        typeCamera: 'Selfie Dengan KTP',
                      ),
                    ),
                  );

                  if (picturePath != null) {
                    hpBloc.fileControl(File(picturePath));
                    await rxPrefs.setString('gambar_change_hp', picturePath);
                  }
                },
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget ambilSelfie(UpdateHpBloc hpBloc) {
    return GestureDetector(
      onTap: () async {
        final cameras = await availableCameras();
        final firstCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );
        final picturePath = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraWidget(
              camera: firstCamera,
              typeCamera: 'Selfie Dengan KTP',
            ),
          ),
        );

        if (picturePath != null) {
          hpBloc.fileControl(File(picturePath));
          await rxPrefs.setString('gambar_change_hp', picturePath);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: DottedBorder(
            color: HexColor(primaryColorHex),
            strokeWidth: 1,
            dashPattern: [10, 6],
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: HexColor(primaryColorHex),
                  ),
                  const SizedBox(height: 8),
                  Subtitle2(
                    text: 'Ambil selfie dengan KTP',
                    color: HexColor(primaryColorHex),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
