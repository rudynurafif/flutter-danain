import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../layout/appBar_previousTitleCustom.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/camera/camera.dart';
import '../../../../widgets/camera/camera_package.dart';
import '../../../../widgets/text/headline.dart';
import '../../../../widgets/text/subtitle.dart';
import '../verifikasi_bloc.dart';

class FotoSelfie extends StatefulWidget {
  final VerifikasiBloc verifBloc;

  const FotoSelfie({Key? key, required this.verifBloc}) : super(key: key);

  @override
  State<FotoSelfie> createState() => _FotoSelfieState();
}

class _FotoSelfieState extends State<FotoSelfie> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        widget.verifBloc.selfieControl(File(''));
        widget.verifBloc.stepControl(2);
        return true;
      },
      child: Scaffold(
        appBar: previousTitleCustom(context, 'Unggah Selfie', () {
          widget.verifBloc.stepControl(2);
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
                StreamBuilder<File>(
                  stream: widget.verifBloc.selfieFileStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            alignment: FractionalOffset.center,
                            image: FileImage(snapshot.data!),
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
          child: StreamBuilder<File>(
            stream: widget.verifBloc.selfieFileStream,
            builder: (context, snapshot) {
              bool isValid = false;
              if (snapshot.hasData) {
                isValid = true;
              }
              return Button1(
                btntext: 'Unggah Foto Selfie',
                color: isValid ? null : HexColor('#ADB3BC'),
                action: isValid
                    ? () {
                        widget.verifBloc.stepControl(2);
                        // ppBloc.ajukanPinjaman();
                      }
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  void _openSelfieCamera(BuildContext context, VerifikasiBloc verifBloc) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
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
      verifBloc.selfieControl(File(picturePath));
      verifBloc.stepControl(4);
      // ppBloc.uploadMaster(context, 'jaminan', 'jaminan');
    }
  }
}
