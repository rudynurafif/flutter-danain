import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/pengajuan_pinjaman/pengajuan_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/pengajuan_pinjaman/pengajuan_pinjaman_gagal.dart';
import 'package:flutter_danain/pages/borrower/after_login/pengajuan_pinjaman/pengajuan_pinjaman_qrcode_page.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PengajuanPinjaman extends StatefulWidget {
  static const routeName = '/pengajuan_pinjaman';
  const PengajuanPinjaman({super.key});

  @override
  State<PengajuanPinjaman> createState() => _PengajuanPinjamanState();
}

class _PengajuanPinjamanState extends State<PengajuanPinjaman> {
  TextEditingController kuponController = TextEditingController();

  final ppBloc = PengajuanPinjamanBloc();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    // ppBloc.requestCheckHavePinjaman();
  }

  @override
  void dispose() {
    ppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    print('pengajuan pinjaman $arguments');
    return StreamBuilder<bool>(
      stream: ppBloc.havePinjaman,
      builder: (context, snapshot) {
        final data = snapshot.data ?? false;
        if (data == false) {
          if (isLoading == true) {
            return const LoadingDanain();
          } else {
            return pengajuanPinjamanWidget(context);
          }
        }
        return PengajuanPinjamanPage2(
          ppBloc: ppBloc,
        );
      },
    );
  }

  Widget bodyBuilder(PengajuanPinjamanBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.fdcController,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        switch (data) {
          case 1:
            return const LoadingDanain();
          case 2:
            return pengajuanPinjamanWidget(context);
          case 3:
            return const PengajuanPinjamanGagal();
          case 4:
            return Scaffold(
              appBar: previousTitle(context, 'Pengajuan Pinjaman'),
              body: const Center(
                child: Subtitle2(text: 'Maaf sepertinya terjadi kesalahan'),
              ),
            );
          default:
            return const LoadingDanain();
        }
      },
    );
  }

  Widget pengajuanPinjamanWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        // Return true to allow the back navigation, or false to prevent it.
        // You can add your custom logic here.
        await Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName, (Route<dynamic> route) => false);
        // Returning true allows the back navigation
        return true;
      },
      child: Scaffold(
        appBar: previousTitleCustom(context, 'Pengajuan Pinjaman', () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomePage.routeName, (Route<dynamic> route) => false);
        }),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Headline3500(text: 'Syarat Pengajuan Pinjaman'),
                const SizedBox(height: 8),
                Subtitle2(
                  text: 'Silakan ambil foto agunan dan bukti pembelian agunan.',
                  color: HexColor('#777777'),
                ),
                const SizedBox(height: 16),
                fotoAgunanWidget(context),
                const SizedBox(height: 16),
                fotoBuktiPembelian(context),
                const SizedBox(height: 24),
                tujuanPinjamanWidget(context),
                const SizedBox(height: 24),
                kuponWidget(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(24),
          height: 94,
          child: StreamBuilder<bool>(
            stream: ppBloc.buttonPinjamanStream,
            builder: (context, snapshot) {
              final isValid = snapshot.data ?? false;
              return Button1(
                btntext: 'Ajukan Pinjaman',
                color: isValid ? null : HexColor('#ADB3BC'),
                action: isValid
                    ? () {
                        ppBloc.ajukanPinjaman();
                      }
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget fotoAgunanWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openAgunanCamera(context, ppBloc);
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
            titlenDesc('Foto Agunan'),
            StreamBuilder<File>(
              stream: ppBloc.agunanFileStream,
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

  Widget fotoBuktiPembelian(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openBuktiCamera(context, ppBloc);
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
            titlenDesc('Foto Bukti Pembelian Agunan (opsional)'),
            StreamBuilder<File?>(
              stream: ppBloc.buktiAgunanFileStream,
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

  Widget tujuanPinjamanWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Tujuan Pinjaman'),
        const SizedBox(height: 12),
        StreamBuilder<String>(
          stream: ppBloc.tujuanPinjamanStream,
          builder: (context, snapshot) {
            final data = snapshot.data ?? '';
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tujuanPinjamanMenu('Produktif', data),
                const SizedBox(width: 8),
                tujuanPinjamanMenu('Konsumtif', data)
              ],
            );
          },
        )
      ],
    );
  }

  Widget tujuanPinjamanMenu(String text, String realText) {
    return GestureDetector(
      onTap: () => ppBloc.tujuanPinjamanController.sink.add(text),
      child: Container(
        width: 98.67,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: text == realText ? const Color(0xffE9F6EB) : Colors.white,
            border: Border.all(
              width: 1,
              color: text == realText
                  ? const Color(0xff8EB69B)
                  : const Color(0xffDDDDDD),
            )),
        child: Center(
          child: Subtitle2(
            text: text,
            color: text == realText
                ? const Color(0xff24663F)
                : const Color(0xff777777),
          ),
        ),
      ),
    );
  }

  Widget kuponWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Makin Hemat dengan Kupon'),
        const SizedBox(height: 12),
        kuponControlWidget(context)
      ],
    );
  }

  Widget kuponControlWidget(BuildContext context) {
    return StreamBuilder<String?>(
      stream: ppBloc.kuponStream,
      builder: (context, snapshot) {
        final bool isNotNull = snapshot.data != null;
        return isNotNull
            ? haveUseKuponWidget(context)
            : haventUseKuponWidget(context);
      },
    );
  }

  Widget haventUseKuponWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: StreamBuilder<String?>(
            stream: ppBloc.kuponTempStream,
            builder: (context, snapshot) {
              String? errorText;
              if (snapshot.hasError) {
                errorText = snapshot.error.toString();
              } else {
                errorText = null;
              }
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: kuponController,
                      onChanged: (value) => ppBloc.changeKupon(value),
                      decoration: inputDecorErrorLeft(
                        context,
                        'Masukan Kupon',
                        snapshot.hasError,
                      ),
                    ),
                    if (snapshot.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 68),
                        child: Subtitle2(
                          text: errorText!,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: 60,
          child: StreamBuilder<bool>(
            stream: ppBloc.buttonGunakanController,
            builder: (context, snapshot) {
              final bool isValid = snapshot.data ?? false;
              return ButtonSmall(
                btntext: 'Gunakan',
                color: isValid ? null : HexColor('#ADB3BC'),
                action: isValid
                    ? () {
                        ppBloc.gunakanKuponPress(kuponController.text);
                      }
                    : null,
              );
            },
          ),
        )
      ],
    );
  }

  Widget haveUseKuponWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: HexColor('#DDDDDD'),
          ),
          borderRadius: BorderRadius.circular(3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/kupon.svg'),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headline3500(
                    text: 'Kode Kupon: ${ppBloc.kuponController.valueOrNull}'),
                const SizedBox(height: 2),
                Subtitle2(
                  text:
                      'Cashback ${ppBloc.messageSuccessController.valueOrNull} pada saat pencairan dana',
                  color: HexColor('#777777'),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ppBloc.batalkanKupon();
              kuponController.clear();
              ppBloc.changeKupon('');
            },
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 20,
            ),
          )
        ],
      ),
    );
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
          color: HexColor('#8EB69B'),
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
        color: data ? HexColor(primaryColorHex) : Colors.transparent,
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

void _openAgunanCamera(
    BuildContext context, PengajuanPinjamanBloc ppBloc) async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  final picturePath = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CameraWidget(
        camera: firstCamera,
        typeCamera: 'Agunan',
      ),
    ),
  );

  if (picturePath != null) {
    print('Captured picture path: $picturePath');
    ppBloc.agunanFile.sink.add(File(picturePath));
    ppBloc.uploadMaster(context, 'jaminan', 'jaminan');
  }
}

void _openBuktiCamera(
  BuildContext context,
  PengajuanPinjamanBloc ppBloc,
) async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  final picturePath = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CameraWidget(
        camera: firstCamera,
        typeCamera: 'Bukti Pembelian Agunan',
      ),
    ),
  );

  if (picturePath != null) {
    print('Captured picture path: $picturePath');
    ppBloc.buktiAgunanFile.sink.add(File(picturePath));
    ppBloc.uploadMaster(context, 'file', 'buktibeli');
  }
}
