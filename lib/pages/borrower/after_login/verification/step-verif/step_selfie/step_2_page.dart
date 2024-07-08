import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_danain/component/verification/list_tips_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/cache.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class Step2Verif extends StatefulWidget {
  final StepVerifBloc stepBloc;
  const Step2Verif({super.key, required this.stepBloc});

  @override
  State<Step2Verif> createState() => _Step2VerifState();
}

class _Step2VerifState extends State<Step2Verif>
    with AutomaticKeepAliveClientMixin {
  int stepIndex = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.stepBloc.selfieController.hasValue
        ? step2Selfie(context)
        : step1Selfie(context);
  }

  Widget step1Selfie(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline1500(text: 'Panduan Foto Selfie'),
            const SizedBox(height: 24),
            SvgPicture.asset(
              'assets/images/verification/take_swafoto.svg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: tipsnTrickWidget(context, panduanSelfie),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 94,
        child: Button1(
          btntext: 'Ambil Foto Selfie',
          action: () {
            _openCameraSelfie(context);
          },
        ),
      ),
    );
  }

  Widget step2Selfie(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline2500(text: 'Tinjauan Foto Selfie'),
              const SizedBox(height: 6),
              Subtitle2(
                text:
                    'Mohon periksa kembali foto Anda dan pastikan wajah terlihat jelas',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 212,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(widget.stepBloc.selfieController.value),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      _openCameraSelfie(context);
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
                      text: 'Ambil Ulang Foto Selfie',
                      color: HexColor(primaryColorHex),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                  btntext: 'Lanjut',
                  action: () {
                    widget.stepBloc.uploadSelfie(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openCameraSelfie(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      // ignore: use_build_context_synchronously
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
        setState(() {
          stepIndex = 2;
        });
        File file = File(picturePath);
        widget.stepBloc.selfieController.sink.add(file);
        await saveToCacheString('selfie_file', picturePath);
        debugPrint('Captured picture path: $picturePath');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      context.showSnackBarError('Ada yang salah: ${e.toString()}');
    }
  }
}
