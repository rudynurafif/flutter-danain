import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../../../../../../../widgets/widget_element.dart';

class Step3UpdateEmail extends StatefulWidget {
  final UbahEmailBloc emailBloc;
  const Step3UpdateEmail({super.key, required this.emailBloc});

  @override
  State<Step3UpdateEmail> createState() => _Step3UpdateEmailState();
}

class _Step3UpdateEmailState extends State<Step3UpdateEmail> {
  TextEditingController emailOldController = TextEditingController();
  TextEditingController emailNewController = TextEditingController();

  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
    final bloc = widget.emailBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Ubah Alamat Email', () {
        bloc.stepControl(2);
      }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              emailOld(bloc),
              const SizedBox(height: 16),
              emailNew(bloc),
              const SizedBox(height: 16),
              lastWidgetControl(bloc),
              const SizedBox(height: 24),
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
              stream: bloc.buttonChangeEmail,
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

  void showAlertNotification(UbahEmailBloc bloc) {
    showDialog(
      context: context,
      builder: (context) => ModalPopUp(
        icon: 'assets/images/icons/edit_icon.svg',
        title: 'Pengajuan Perubahan Email',
        message:
            'Proses verifikasi data memerlukan waktu kurang lebih 1x24 jam',
        actions: [
          Button2(
            btntext: 'Ajukan Perubahan',
            action: () {
              bloc.submitChangeEmail();
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
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

  Widget emailOld(UbahEmailBloc bloc) {
    return StreamBuilder(
      stream: bloc.authState,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data!.map((value) {
            emailOldController.text = value.userAndToken!.user.email;
          });
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Alamat Email Terdaftar',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Container(
              color: HexColor('#F5F6F7'),
              child: AbsorbPointer(
                child: TextFormField(
                  style: TextStyle(color: HexColor('#999999')),
                  decoration: inputDecorNoError(context, 'Contoh: jhondoebaru@gmail.com'),
                  controller: emailOldController,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget emailNew(UbahEmailBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.emailError,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Alamat Email Terdaftar',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  decoration:
                      inputDecor(context, 'Contoh: jhondoebaru@gmail.com', snapshot.hasData),
                  controller: emailNewController,
                  onChanged: (value) => bloc.newEmailControl(value),
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

  Widget lastWidgetControl(UbahEmailBloc bloc) {
    return StreamBuilder<File>(
      stream: bloc.fileStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return selfie(bloc);
        } else {
          return ambilSelfie(bloc);
        }
      },
    );
  }

  Widget ambilSelfie(UbahEmailBloc bloc) {
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
          bloc.fileControl(File(picturePath));
          await rxPrefs.setString('gambar_change_email', picturePath);
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

  Widget selfie(UbahEmailBloc bloc) {
    return StreamBuilder<File>(
      stream: bloc.fileStream,
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
                    bloc.fileControl(File(picturePath));
                    await rxPrefs.setString('gambar_change_email', picturePath);
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
}
