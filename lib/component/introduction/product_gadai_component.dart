// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_danain/component/auxpage/search_location_2.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/lokasi_penyimpanan_emas_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/pinjaman/simulasi_pinjaman_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/constants.dart';
import '../../layout/footer_Lisence.dart';
import 'contentmenu_component.dart';
import 'faqandchat_component.dart';
import 'package:permission_handler/permission_handler.dart';

Widget gadaiEmasContent(BuildContext context) {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageGadaiContent(context),
          firstGadaiProductContent(context),
          dividerFull(context),
          lastGadaiProductContent(context),
          footerLisence(context)
        ],
      ),
    ),
  );
}

Widget imageGadaiContent(BuildContext context) {
  return LayoutBuilder(
    builder: (context, BoxConstraints constraints) {
      return Container(
        width: constraints.maxWidth,
        child: SvgPicture.asset(
          'assets/images/preference/produk_gadai_emas.svg',
          fit: BoxFit.fitWidth,
        ),
      );
    },
  );
}

Widget firstGadaiProductContent(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline2(
          text: pinjamanIntroduction,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        const Subtitle2(
          text: pinjamanDesc,
          align: TextAlign.start,
          color: Color(0xff777777),
        ),
        const SizedBox(height: 16),
        Container(
          // padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: const Color(0xFFF0F0F0)),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 0,
                )
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/preference/maxi_150.svg',
                          allowDrawingOutsideViewBox: true,
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Headline4(text: 'Maxi 150'),
                            SizedBox(height: 8),
                            Subtitle2(
                              text: '12% per annum',
                              color: Color(0xFFAAAAAA),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset('assets/images/preference/bubble.svg')
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 0, right: 16, left: 16, bottom: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.3,
                            color: const Color.fromARGB(142, 208, 208, 208)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tenor',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10),
                            ),
                            SizedBox(height: 4),
                            Headline5(
                              text: '150 Hari',
                              color: Colors.black,
                            )
                          ],
                        ),
                        SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nilai Pinjaman',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10),
                            ),
                            SizedBox(height: 4),
                            Headline5(text: 'Rp 200.000 s.d. Rp 2.000.000.000')
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget lastGadaiProductContent(BuildContext context) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            ContentMenu(
              image: 'assets/images/preference/simulasi_pinjaman.svg',
              title: pinjamanContent1,
              subtitle: pinjamanContentSub1,
              icon: true,
              navigate: () {
                Navigator.pushNamed(context, SimulasiPinjaman.routeName);
              },
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              decoration: const BoxDecoration(color: Color(0xffEEEEEE)),
            ),
            const SizedBox(height: 16),
            contentMitraGadai(context)
          ],
        ),
      ),
      const SizedBox(height: 16),
      faqAndChat(context)
    ],
  );
}

Widget contentMitraGadai(BuildContext context) {
  final TextEditingController provinsiController = TextEditingController();
  return ContentMenu(
    image: 'assets/images/preference/lokasi_penyimpan_emas.svg',
    title: pinjamanContent2,
    subtitle: pinjamanContentSub2,
    icon: true,
    navigate: () async {
      final PermissionStatus status = await Permission.location.status;
      if (status == PermissionStatus.granted) {
        context.showSnackBarSuccess('Mohon Tunggu...');
        checkLocationInfo(provinsiController, null, () {
          Navigator.pushNamed(
            context,
            PenyimpananEmas.routeName,
            arguments: PenyimpananEmas(
              provinceName: provinsiController.text,
            ),
          );
        });
      } else {
        await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (ctx) => ModaLBottom(
            image: 'assets/images/register/aktifkan_lokasi.svg',
            title: locationActive,
            subtitle: locationActiveSub,
            action: SearchLocation2(
              textButton: agreeText,
              provinsi: provinsiController,
              nextAction: () {
                print('provinsi ku: ${provinsiController.text}');
                Navigator.popAndPushNamed(
                  context,
                  PenyimpananEmas.routeName,
                  arguments: PenyimpananEmas(
                    provinceName: provinsiController.text,
                  ),
                );
              },
            ),
          ),
        );
      }
    },
  );
}
