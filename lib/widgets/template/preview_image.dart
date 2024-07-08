import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:hexcolor/hexcolor.dart';

Widget imageBuilder(String type, String filePath) {
  if (type == 'KTP' || type == 'SIM') {
    return idCardImage(File(filePath));
  } else if (type == 'KK') {
    return kkImage(File(filePath));
  } else {
    return generalImage(File(filePath));
  }
}

Widget idCardImage(File fileImage) {
  return Container(
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
            image: FileImage(fileImage),
          ),
        ),
      ),
    ),
  );
}

Widget kkImage(File fileImage) {
  return Container(
    width: double.infinity,
    height: 200, // Adjust the container's height as needed
    color: Colors.grey,
    child: Transform.rotate(
      angle: 90 * (3.141592653589793 / 180),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            fit: BoxFit
                .contain, // Use BoxFit.contain to fit the image inside the container
            alignment: FractionalOffset.center,
            image: FileImage(fileImage),
          ),
        ),
      ),
    ),
  );
}

Widget generalImage(File fileImage) {
  return Center(
    child: Container(
      width: 212,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(fileImage),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

class PreviewImage extends StatelessWidget {
  final String filePath;
  final String type;
  final VoidCallback retakeAction;
  final VoidCallback takeAction;
  const PreviewImage({
    super.key,
    required this.filePath,
    required this.type,
    required this.retakeAction,
    required this.takeAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousCustomWidget(context, () async {
        try {
          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
            print('File deleted: $filePath');
          } else {
            print('File not found: $filePath');
          }
        } catch (e) {
          print('Error deleting file: $e');
        }
        Navigator.pop(context);
      }),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline2500(text: 'Tinjauan Foto'),
            SizedBox(height: 8),
            Subtitle2(
              text:
                  'Mohon periksa kembali foto Anda dan pastikan informasi terlihat jelas',
              color: HexColor('#777777'),
            ),
            SizedBox(
              height: 24,
            ),
            imageBuilder(type, filePath),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 32,
                child: ElevatedButton(
                  onPressed: retakeAction,
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
                    text: 'Ambil Ulang Foto',
                    color: HexColor(primaryColorHex),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Button1(
              btntext: 'Unggah Foto',
              action: takeAction,
            ),
          ],
        ),
      ),
    );
  }
}
