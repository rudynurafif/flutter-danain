import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../widgets/button/button.dart';
import '../../../../widgets/camera/camera.dart';
import '../../../../widgets/camera/camera_package.dart';
import '../../../../widgets/text/headline.dart';
import '../../../../widgets/text/subtitle.dart';
import '../verifikasi_bloc.dart';

class PengisianDataPage extends StatefulWidget {
  final VerifikasiBloc verifBloc;
  const PengisianDataPage({super.key, required this.verifBloc});

  @override
  State<PengisianDataPage> createState() => _PengisianDataPageState();
}

class _PengisianDataPageState extends State<PengisianDataPage> {
  int stepLocal = 0;
  String optionLocal = '';
  String ktpData = '';
  String selfieData = '';

  @override
  Widget build(BuildContext context) {
    return stepLocal == 1
        ? optionLocal == 'ktp'
            ? detailKtp()
            : detailSelfie()
        : picWidget();
  }

  Widget picWidget() {
    return Scaffold(
      appBar: previousTitleCustom(context, 'Pengisian Data', () {
        widget.verifBloc.stepControl(0);
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Ambil Foto KTP dan Foto Selfie'),
              const SizedBox(height: 16),
              fotoKtpWidget(context, widget.verifBloc),
              const SizedBox(height: 16),
              fotoSelfieWidget(context, widget.verifBloc),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Lanjut',
          color: widget.verifBloc.imaggeSelfieValue.hasValue &&
                  widget.verifBloc.imaggeSelfieValue.hasValue
              ? null
              : HexColor('#ADB3BC'),
          action: widget.verifBloc.imaggeSelfieValue.hasValue &&
                  widget.verifBloc.imaggeSelfieValue.hasValue
              ? () {
                  widget.verifBloc.stepControl(2);
                }
              : null,
        ),
      ),
    );
  }

  Widget fotoKtpWidget(BuildContext context, VerifikasiBloc verifBloc) {
    return GestureDetector(
      onTap: () {
        verifBloc.stepControl(1);
        optionLocal = 'ktp';
        if (verifBloc.imageKtpValue.hasValue) {
          stepLocal = 1;
        } else {
          _openKtpCamera(context, verifBloc);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor('#DDDDDD'),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titlenDesc('Ambil Foto KTP'),
            StreamBuilder<File>(
              stream: verifBloc.ktpFileStream,
              builder: (context, snapshot) {
                bool data = false;
                if (snapshot.hasData) {
                  data = true;
                }
                return checkCircle(data);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget fotoSelfieWidget(BuildContext context, VerifikasiBloc verifBloc) {
    return GestureDetector(
      onTap: () {
        verifBloc.stepControl(1);
        optionLocal = 'selfie';
        if (verifBloc.imaggeSelfieValue.hasValue) {
          stepLocal = 1;
        } else {
          _openSelfieCamera(context, verifBloc);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor('#DDDDDD'),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titlenDesc('Ambil Foto Selfie'),
            StreamBuilder<File>(
              stream: verifBloc.selfieFileStream,
              builder: (context, snapshot) {
                bool data = false;
                if (snapshot.hasData) {
                  data = true;
                }
                return checkCircle(data);
              },
            )
          ],
        ),
      ),
    );
  }

  void _openKtpCamera(BuildContext context, VerifikasiBloc verifBloc) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    final picturePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraWidget(
          camera: firstCamera,
          typeCamera: 'KTP',
        ),
      ),
    );

    if (picturePath != null) {
      print('Captured picture path: $picturePath');
      stepLocal = 1;
      ktpData = picturePath;
      verifBloc.ktpControl(File(picturePath));
      verifBloc.stepControl(1);
      // ppBloc.uploadMaster(context, 'jaminan', 'jaminan');
    }
  }

  void _openSelfieCamera(BuildContext context, VerifikasiBloc verifBloc) async {
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
          typeCamera: 'Selfie',
        ),
      ),
    );

    if (picturePath != null) {
      print('Captured picture path: $picturePath');
      stepLocal = 1;
      selfieData = picturePath;
      verifBloc.selfieControl(File(picturePath));
      verifBloc.stepControl(1);
    }
  }

  Widget titlenDesc(String data) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 24,
            color: HexColor(lenderColor),
          ),
          const SizedBox(width: 16),
          Flexible(child: SubtitleExtra(text: data))
        ],
      ),
    );
  }

  Widget checkCircle(bool data) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: data ? HexColor(lenderColor) : Colors.transparent,
        ),
        child: data
            ? const Center(
                child: Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }

  Widget detailSelfie() {
    return Scaffold(
      appBar: previousTitleCustom(context, 'Unggah Selfie', () {
        widget.verifBloc.stepControl(1);
        stepLocal = 0;
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Tinjauan Foto Selfie'),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Mohon periksa kembali foto Selfie Anda dan pastikan data terlihat jelas',
                color: HexColor('#777777'),
                align: TextAlign.left,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: StreamBuilder<File>(
                    stream: widget.verifBloc.selfieFileStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.center,
                              image: FileImage(snapshot.data!),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.center,
                              image: FileImage(File(selfieData)),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      _openSelfieCamera(context, widget.verifBloc);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(
                              color: HexColor(lenderColor), width: 1),
                        ),
                      ),
                    ),
                    child: Headline5(
                      text: 'Ambil Ulang Foto Selfie',
                      color: HexColor(lenderColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Unggah Foto Selfie',
          action: () async {
            stepLocal = 0;
            widget.verifBloc.stepControl(1);
            widget.verifBloc.selfieControl(File(selfieData));
            await Future.delayed(const Duration(seconds: 2));
            widget.verifBloc.sendPhotoSelfie();
          },
        ),
      ),
    );
  }

  Widget detailKtp() {
    return Scaffold(
      appBar: previousTitleCustom(context, 'Unggah KTP', () {
        widget.verifBloc.stepControl(1);
        stepLocal = 0;
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Tinjauan Foto KTP'),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Mohon periksa kembali foto KTP Anda dan pastikan data terlihat jelas',
                color: HexColor('#777777'),
                align: TextAlign.left,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: StreamBuilder<File>(
                    stream: widget.verifBloc.ktpFileStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.center,
                              image: FileImage(snapshot.data!),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.center,
                              image: FileImage(File(ktpData.toString())),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      _openKtpCamera(context, widget.verifBloc);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(
                              color: HexColor(lenderColor), width: 1),
                        ),
                      ),
                    ),
                    child: Headline5(
                      text: 'Ambil Ulang Foto KTP',
                      color: HexColor(lenderColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Unggah Foto KTP',
          action: () async {
            stepLocal = 0;

            widget.verifBloc.ktpControl(File(ktpData));
            widget.verifBloc.stepControl(1);
            await Future.delayed(const Duration(seconds: 2));
            widget.verifBloc.sendPhotoKtp();
          },
        ),
      ),
    );
  }
}
