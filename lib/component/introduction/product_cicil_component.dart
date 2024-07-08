import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/supplier_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/simulasi_cicilan_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/constants.dart';
import '../../layout/footer_Lisence.dart';
import 'contentmenu_component.dart';
import 'faqandchat_component.dart';

Widget cicilEmasContent(BuildContext context) {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageCicilContent(context),
          firstCicilContent(context),
          dividerFull(context),
          lastCicilContent(context),
          footerLisence(context)
        ],
      ),
    ),
  );
}

Widget imageCicilContent(BuildContext context) {
  return LayoutBuilder(
    builder: (context, BoxConstraints constraints) {
      return Container(
        width: constraints.maxWidth,
        child: SvgPicture.asset(
          'assets/images/preference/produk_cicil_emas.svg',
          fit: BoxFit.fitWidth,
        ),
      );
    },
  );
}

Widget firstCicilContent(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline2(
          text: cicilPreferenceTitle,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        const Subtitle2(
          text: cicilPreferenceSubtitle,
          align: TextAlign.start,
          color: Color(0xff777777),
        ),
        const SizedBox(height: 16),
        const Headline2(
          text: cicilPreferenceTitle2,
          align: TextAlign.start,
        ),
        const SizedBox(height: 16),
        ContentMenu(
          image: 'assets/images/preference/kunci_harga_emas.svg',
          title: cicilEmasMenu1,
          subtitle: cicilEmasMenuSub1,
          icon: false,
        ),
        const SizedBox(height: 16),
        ContentMenu(
          image: 'assets/images/preference/uang_muka_terjangkau.svg',
          title: cicilEmasMenu2,
          subtitle: cicilEmasMenuSub2,
          icon: false,
        ),
        const SizedBox(height: 16),
        ContentMenu(
          image: 'assets/images/preference/pilihan_tenor_bervariasi.svg',
          title: cicilEmasMenu3,
          subtitle: cicilEmasMenuSub3,
          icon: false,
        ),
      ],
    ),
  );
}

Widget lastCicilContent(BuildContext context) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffEEEEEE), width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ContentMenu(
                image: 'assets/images/preference/simulasi_cicilan.svg',
                title: cicilEmasContent1,
                subtitle: cicilEmasContentSub1,
                icon: true,
                navigate: () {
                  Navigator.pushNamed(context, SimulasiCicilanEmas.routeName);
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              decoration: const BoxDecoration(color: Color(0xffEEEEEE)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: mitraCicilContent(context),
            )
          ],
        ),
      ),
      const SizedBox(height: 16),
      faqAndChat(context)
    ],
  );
}

Widget mitraCicilContent(BuildContext context) {
  return ContentMenu(
    image: 'assets/images/preference/jangkauan_supplier_emas.svg',
    title: cicilEmasContent2,
    subtitle: cicilEmasContentSub2,
    icon: true,
    navigate: () {
      Navigator.pushNamed(context, SupplierEmasPage.routeName);
    },
  );
}
