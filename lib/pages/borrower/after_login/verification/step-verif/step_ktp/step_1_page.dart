import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/cache.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_danain/component/verification/verification_component.dart';

class Step1Verif extends StatefulWidget {
  final StepVerifBloc stepBloc;
  const Step1Verif({super.key, required this.stepBloc});

  @override
  State<Step1Verif> createState() => _Step1VerifState();
}

class _Step1VerifState extends State<Step1Verif> {
  List<String> tipsnTrickTake = [
    'Pastikan Anda Mengunggah foto KTP asli. Bukan hasil scan atau fotokopi.',
    'Pastikan KTP terlihat jelas dalam kotak foto dan tidak blur.',
    'Informasi pada KTP harus terlihat jelas (tidak tergores/terkelupas).',
    'Foto ktp harus terlihat jelas (tidak tergores/terkelupas).',
  ];
  int stepIndex = 1;

  @override
  Widget build(BuildContext context) {
    return widget.stepBloc.ktpFileController.hasValue
        ? stepKtp2(context)
        : stepKtp1(context);
  }

  Widget stepKtp1(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline2500(text: 'Panduan Ambil Foto KTP'),
            const SizedBox(height: 24),
            SvgPicture.asset(
              'assets/images/verification/example_ktp.svg',
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: tipsnTrickWidget(context, tipsnTrickTake),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Ambil Foto KTP',
          action: () {
            _openCamera(context);
          },
        ),
      ),
    );
  }

  Widget stepKtp2(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline2500(text: 'Tinjauan Foto KTP'),
            const SizedBox(height: 6),
            Subtitle2(
              text:
                  'Mohon periksa kembali foto KTP Anda dan pastikan data terlihat jelas',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.center,
                      image: FileImage(widget.stepBloc.ktpFileController.value),
                    ),
                  ),
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
                    _openCamera(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: const BorderSide(
                            color: Color(0xff24663F), width: 1),
                      ),
                    ),
                  ),
                  child: Headline5(
                    text: 'Ambil Ulang Foto KTP',
                    color: HexColor(primaryColorHex),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: StreamBuilder<bool>(
              stream: widget.stepBloc.isLoadingStream,
              builder: (context, snapshot) {
                final isLoading = snapshot.data ?? false;
                if (isLoading == true) {
                  return const ButtonLoading();
                }
                return Button1(
                  btntext: 'Unggah Foto KTP',
                  action: () {
                    widget.stepBloc.uploadKtp(context);
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    // ignore: use_build_context_synchronously
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
      setState(() {
        stepIndex = 2;
      });
      final File file = File(picturePath);
      widget.stepBloc.ktpFileController.sink.add(file);
      await saveToCacheString('ktp_file', picturePath);
      debugPrint('Captured picture path: $picturePath');
    }
  }
}
