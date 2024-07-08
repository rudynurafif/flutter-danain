import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/menu/help/help_page.dart';
import 'package:flutter_danain/pages/borrower/register/register_page.dart';
import 'package:flutter_danain/pages/borrower/registerNew/registerNew_Page.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/constants.dart';
Widget faqAndChat(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Button1(
          btntext: registerText,
          action: () {
            Navigator.pushNamed(context, RegisterIndex.routeName);
          },
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, HelpTemporary.routeName);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color.fromARGB(
                  218,
                  214,
                  246,
                  215,
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/images/preference/question.svg',
                          width: 52, height: 52),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Headline5(text: faq1, align: TextAlign.start),
                            SizedBox(height: 4),
                            Subtitle2(
                              text: faqDesc,
                              align: TextAlign.start,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xff24663F),
                    size: 20,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Headline4(
          text: faqDanain,
          color: Color(0xff5F5F5F),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            const url = urlChat;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: HeadlineBold4(text: faqHelper, color: const Color(0xff288C50)),
        )
      ],
    ),
  );
}

