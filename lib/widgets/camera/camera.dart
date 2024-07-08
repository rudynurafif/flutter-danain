import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  final String typeCamera;
  const CameraWidget({
    super.key,
    required this.camera,
    required this.typeCamera,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  String? errorText;
  Future<void> initCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;

      if (mounted) {
        setState(() {});
      }
    } on CameraException catch (e) {
      setState(() {
        errorText = 'Camera error: ${e.description}';
      });
      debugPrint("Camera error: ${e.description}");
    }
  }

  final foto = BehaviorSubject<String?>();

  @override
  void initState() {
    super.initState();
    initCamera(widget.camera);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline3500(
              text: 'Ambil Foto ${widget.typeCamera}',
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            const Text(
              'Pastikan Anda mengambil foto di area yang tersedia dan foto harus terlihat jelas',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: _controller.value.isInitialized
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: cameraBuilder(widget.typeCamera),
            )
          : Center(
              child: Subtitle1(
                text: errorText ?? '',
                color: Colors.white,
              ),
            ),
      bottomNavigationBar: buttonCapture(),
    );
  }

  Widget buttonCapture() {
    return Container(
      height: 100,
      color: Colors.transparent,
      child: StreamBuilder<String?>(
        stream: foto.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return holdImage();
          }
          return captureImage();
        },
      ),
    );
  }

  Widget holdImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                foto.add(null);
              },
              child: SvgPicture.asset('assets/images/icons/rotate.svg'),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                try {
                  Navigator.pop(context, foto.valueOrNull);
                } catch (e) {
                  context.showSnackBarError(
                    'Error saat mengambil foto ${e.toString()}',
                  );
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  Widget captureImage() {
    return GestureDetector(
      onTap: () async {
        try {
          await _initializeControllerFuture;
          await _controller.setFlashMode(FlashMode.off);
          final picture = await _controller.takePicture();
          final String resizedImagePath = await resizeImage(picture.path);
          print('Picture captured: ${picture.path}');
          foto.add(resizedImagePath);
        } catch (e) {
          print("Error taking picture: $e");
        }
      },
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: 5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget cameraBuilder(String type) {
    return StreamBuilder<String?>(
      stream: foto.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final path = snapshot.data ?? '';
          final File file = File(path);
          return Image.file(
            file,
            width: MediaQuery.of(context).size.width,
          );
        }
        switch (type) {
          case 'KTP':
            return idCardCamera();
          case 'SIM':
            return idCardCamera();
          case 'KK':
            return generalCamera();
          case 'Selfie':
            return selfiCamera();
          case 'Selfie Dengan KTP':
            return selfieKtp();
          case 'Agunan':
            return generalCamera();
          case 'Bukti Pembelian Agunan':
            return generalCamera();
          default:
            return generalCamera();
        }
      },
    );
  }

  Widget idCardCamera() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CameraPreview(_controller),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: DottedBorder(
            color: Colors.white,
            strokeWidth: 1,
            dashPattern: [10, 6],
            child: Container(),
          ),
        ),
      ],
    );
  }

  Widget generalCamera() {
    return CameraPreview(_controller);
  }

  Widget selfiCamera() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CameraPreview(_controller),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SizedBox(
            width: 200,
            height: 250,
            child: CustomPaint(
              painter: DottedEllipsePainter(),
            ),
          ),
        ),
      ],
    );
  }

  Widget selfieKtp() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CameraPreview(_controller),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SizedBox(
            width: 200,
            height: 250,
            child: CustomPaint(
              painter: DottedEllipsePainter(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 350),
          child: SizedBox(
            width: 200,
            height: 130,
            child: DottedBorder(
              color: Colors.white,
              strokeWidth: 1,
              dashPattern: [10, 6],
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }
}

Future<String> resizeImage(String originalImagePath) async {
  final file = File(originalImagePath);

  // Compress and resize the image
  Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    quality: 85, // Adjust the quality as needed
  );

  // Create a new File with the compressed image data
  String resizedImagePath =
      originalImagePath.replaceFirst('.jpg', '_resized.jpg');
  File resizedFile = File(resizedImagePath);
  await resizedFile.writeAsBytes(compressedBytes!);

  return resizedImagePath;
}
