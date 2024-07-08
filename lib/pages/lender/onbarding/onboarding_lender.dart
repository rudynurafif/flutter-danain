import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_LogoPrevious.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/lender/login/login_page.dart';
import 'package:flutter_danain/pages/lender/register/register_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class OnboardingLender extends StatefulWidget {
  const OnboardingLender({super.key});

  @override
  State<OnboardingLender> createState() => _OnboardingLenderState();
}

class _OnboardingLenderState extends State<OnboardingLender> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  final dataSlider = [
    {
      'images': 'assets/lender/onboarding/slider_2.svg',
      'title': 'Pengembangan Dana Mudah',
      'subtitle':
          'Pendanaan mudah dan praktis bisa dilakukan kapan saja dan di mana saja'
    },
    {
      'images': 'assets/lender/onboarding/slider_3.svg',
      'title': 'Berizin dan Diawasi OJK',
      'subtitle':
          'Pendanaan aman dan terpercaya karena telah berizin resmi dan diawasi oleh OJK'
    },
    {
      'images': 'assets/lender/onboarding/slider_1.svg',
      'title': 'Pendanaan dengan Agunan',
      'subtitle':
          'Pendanaan aman dengan agunan di setiap pinjaman, menjamin pokok dan bunga keuntungan 100% kembali'
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
              const SizedBox(height: 70),
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
                color: HexColor(lenderColor),
                action: () {
                  rxPrefs.remove('email_ubah');
                  Navigator.pushNamed(context, RegistrasiLenderPage.routeName);
                },
              ),
              const SizedBox(height: 16),
              Button1(
                btntext: 'Masuk',
                textcolor: HexColor(lenderColor),
                color: Colors.white,
                action: () {
                  Navigator.pushNamed(context, LoginLenderPage.routeName);
                  // Navigator.pushNamed(
                  //   context,
                  //   HomePageLender.routeNeme,
                  // );
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
          height: 300,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset(
                    data['images']!,
                    width: 200,
                    height: 140,
                  ),
                  const SizedBox(height: 60),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Headline2(
                          text: data['title']!,
                          align: TextAlign.center,
                          color: HexColor(lenderColor),
                        ),
                        const SizedBox(height: 15),
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
