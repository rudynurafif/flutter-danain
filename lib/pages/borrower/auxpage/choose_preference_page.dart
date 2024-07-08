import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_danain/data/constants.dart';

import 'package:flutter_danain/layout/appBar_LogoPrevious.dart';
import 'package:flutter_danain/layout/footer_Lisence.dart';
import 'package:flutter_danain/pages/borrower/auxpage/introduction_product_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class ChoosePreference extends StatefulWidget {
  static const routeName = '/choose_preference_page';
  const ChoosePreference({super.key});

  @override
  State<ChoosePreference> createState() => _ChoosePreferenceState();
}

class _ChoosePreferenceState extends State<ChoosePreference> {
  int? _currentIndex = null;

  Color? gadai = null;
  Color? cicil = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: logoPreviousWidget(context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.only(top: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Headline1(
                text: chooseTitle,
                align: TextAlign.center,
                color: Color(0xFF333333),
              ),
              SizedBox(height: 8),
              Subtitle2(
                text: chooseSubtitle,
                align: TextAlign.center,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                        gadai = Color(0xff288C50);
                        cicil = null;
                      });
                    },
                    child: CardPreference(
                      image: 'assets/images/preference/gadai_emas.svg',
                      title: pinjamanCard,
                      subtitle: pinjamanCardSubtitle,
                      borderColor: gadai,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                        cicil = Color(0xff288C50);
                        gadai = null;
                      });
                    },
                    child: CardPreference(
                      image: 'assets/images/preference/cicil_emas.svg',
                      title: cicilanCardTitle,
                      subtitle: cicilanCardSubtitle,
                      borderColor: cicil,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Button1(
                btntext: nextText,
                color: _currentIndex == null ? Colors.grey : null,
                action: _currentIndex == null
                    ? null
                    : () {
                        // print(_currentIndex);
                        Navigator.pushNamed(
                          context,
                          IntroductionProduct.routeName,
                          arguments: IntroductionProduct(
                            content: _currentIndex.toString(),
                          ),
                        );
                      },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: footerLisence(context),
    );
  }
}

class CardPreference extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color? borderColor;
  CardPreference(
      {required this.image,
      required this.title,
      required this.subtitle,
      this.borderColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: 172,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : Border.all(color: Colors.transparent, width: 0),
        gradient: new LinearGradient(
          begin: const Alignment(0.0, 0.6),
          end: const Alignment(0.0, -1),
          colors: <Color>[
            Colors.white,
            Color.fromARGB(255, 228, 255, 248),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(image),
          // SizedBox(height: 8),
          Headline4(text: title),
          SizedBox(
            height: 8,
          ),
          Subtitle3(
            text: subtitle,
            align: TextAlign.center,
            color: Color(0xFF333333),
          ),
        ],
      ),
    );
  }
}
