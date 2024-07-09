import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_LogoPrevious.dart';
import 'package:flutter_danain/layout/footer_Lisence.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_page.dart';
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
  final List<SliderWidget> listSlider = [
    const SliderWidget(
      image: 'assets/images/onboarding/pinjaman_beragunan_emas.svg',
      title: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: 'Pinjaman beragunan BPKB dengan ',
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'Cash & Drive',
            style: TextStyle(
              color: Color(0xff24663F),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]),
        textAlign: TextAlign.center,
      ),
      subtitle:
          'Miliki aset emas untuk Masa depan! Angsuran  dengan harga terjamin dan keamanan emas tersimpan di mitra penyimpan terpercaya.',
    ),
    const SliderWidget(
      image: 'assets/images/onboarding/pinjaman_beragunan_emas.svg',
      title: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: 'Pinjaman beragunan ',
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'Emas ',
            style: TextStyle(
              color: Color(0xff24663F),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: 'aman dan mudah prosesnya',
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ]),
        textAlign: TextAlign.center,
      ),
      subtitle:
          'Miliki aset emas untuk Masa depan! Angsuran  dengan harga terjamin dan keamanan emas tersimpan di mitra penyimpan terpercaya.',
    ),
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
              buttonSlider(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Button1(
                      btntext: 'Buat Akun Baru',
                      color: HexColor(borrowerColor),
                      action: () {
                        Navigator.pushNamed(
                          context,
                          NewRegisterBorrowerPage.routeName,
                        );
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
            ],
          ),
        ),
        bottomNavigationBar: footerLisence(context),
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
        itemCount: listSlider.length,
        itemBuilder: (context, index, realIndex) {
          final data = listSlider[realIndex];
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
                  data.image,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      data.title,
                      const SizedBox(height: 5),
                      Subtitle2(
                        text: data.subtitle,
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
        for (int i = 0; i < listSlider.length; i++)
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

class SliderWidget {
  final String image;
  final Widget title;
  final String subtitle;

  const SliderWidget({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
