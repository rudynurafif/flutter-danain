import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'tips_trick.dart';

Widget ktpPanduanWidget(BuildContext context, VoidCallback action) {
  return Scaffold(
    appBar: previousTitle(context, panduanKtpTitle),
    body: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/verification/example_ktp.svg',
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 24),
          tipsAndTrickWidget(context, panduanKtp),
          const SizedBox(height: 16),
          alertOjk(context),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.all(24),
      height: 94,
      child: Column(
        children: [
          Button1(
            btntext: buttonPanduan,
            action: action,
          )
        ],
      ),
    ),
  );
}

Widget selfieKtpPanduanWidget(BuildContext context, VoidCallback action) {
  return Scaffold(
    appBar: previousTitle(context, panduanSelfieKTPTitle),
    body: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/panduan/selfiektp.svg',
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 24),
          tipsAndTrickWidget(context, panduanSelfieKTP),
          const SizedBox(height: 16),
          alertOjk(context),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.all(24),
      height: 94,
      child: Column(
        children: [
          Button1(
            btntext: buttonPanduan,
            action: action,
          )
        ],
      ),
    ),
  );
}

Widget panduanSelfieWidget(BuildContext context, VoidCallback action) {
  return Scaffold(
    appBar: previousTitle(context, panduanSelfieTitle),
    body: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/verification/take_Selfie.svg',
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 24),
          tipsAndTrickWidget(context, panduanSelfie),
          const SizedBox(height: 16),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.all(24),
      height: 94,
      child: Column(
        children: [
          Button1(
            btntext: buttonPanduan,
            action: action,
          )
        ],
      ),
    ),
  );
}

Widget panduanKkWidget(BuildContext context, VoidCallback action) {
  return Scaffold(
    appBar: previousTitle(context, panduanKkTitle),
    body: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/panduan/sim.svg',
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 24),
          tipsAndTrickWidget(context, panduanKk),
          const SizedBox(height: 16),
          alertOjk(context),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.all(24),
      height: 94,
      child: Column(
        children: [
          Button1(
            btntext: buttonPanduan,
            action: action,
          )
        ],
      ),
    ),
  );
}

Widget panduanSimWidget(BuildContext context, VoidCallback action) {
  return Scaffold(
    appBar: previousTitle(context, panduanSimTitle),
    body: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/panduan/kk.svg',
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 24),
          tipsAndTrickWidget(context, panduanSim),
          const SizedBox(height: 16),
          alertOjk(context),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.all(24),
      height: 94,
      child: Column(
        children: [
          Button1(
            btntext: buttonPanduan,
            action: action,
          )
        ],
      ),
    ),
  );
}

Widget alertOjk(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: const Color(0xffE9F6EB), borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/images/icons/shield.svg'),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline5(text: 'Data Anda Dijamin Aman'),
              const SizedBox(height: 2),
              Subtitle3(
                text:
                    'Kami meminta data sesuai dengan peraturan OJK. Data tidak akan diberikan kepada siapapun tanpa persetujuan Anda.',
                color: HexColor('#777777'),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
