import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_LogoPrevious.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../login/login.dart';
import 'choose_preference_page.dart';

class OnboardingBorrowerPage extends StatefulWidget {
  const OnboardingBorrowerPage({super.key});

  @override
  State<OnboardingBorrowerPage> createState() => _OnboardingBorrowerPageState();
}

class _OnboardingBorrowerPageState extends State<OnboardingBorrowerPage> {
  final dataSlider = [
    {
      'images': 'assets/images/onboarding/pinjaman_beragunan_emas.svg',
      'title': pinjamanCarouselTitle,
      'subtitle': pinjamanCarouselSubtitle
    },
    {
      'images': 'assets/images/onboarding/cicilan_emas.svg',
      'title': cicilanCarouselTitle,
      'subtitle': cicilanCarouselSubtitle
    },
  ];

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: logoPreviousWidget(context),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              slider(),
              const SizedBox(height: 30),
              buttonSlider(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 200,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Button1(
                btntext: 'Buat Akun Baru',
                color: HexColor(borrowerColor),
                action: () {
                  Navigator.pushNamed(context, ChoosePreference.routeName);
                },
              ),
              const SizedBox(height: 16),
              Button1(
                btntext: 'Masuk',
                textcolor: HexColor(borrowerColor),
                color: Colors.white,
                action: () {
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        await Navigator.pushNamedAndRemoveUntil(
            context, PreferencePage.routeName, (route) => false);
        return false;
      },
    );
  }

  Widget slider() {
    return Center(
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        options: CarouselOptions(
          height: 370,
          autoPlay: true,
          enableInfiniteScroll: false,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        itemCount: dataSlider.length,
        itemBuilder: (context, index, realIndex) {
          final data = dataSlider[realIndex];
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = realIndex;
                _carouselController.animateToPage(realIndex);
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  data['images']!,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Headline2(
                        text: data['title']!,
                        align: TextAlign.center,
                        color: HexColor(primaryColorHex),
                      ),
                      const SizedBox(height: 5),
                      Subtitle2(
                        text: data['subtitle']!,
                        align: TextAlign.center,
                        color: HexColor('#777777'),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buttonSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < dataSlider.length; i++)
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = i;
                _carouselController.animateToPage(i);
              });
            },
            child: Container(
              height: _currentIndex == i ? 10 : 8,
              width: _currentIndex == i ? 10 : 8,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _currentIndex == i
                    ? const Color.fromARGB(255, 32, 155, 39)
                    : const Color.fromARGB(255, 182, 182, 182),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _currentIndex == i
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.transparent,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(2, 3),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}
