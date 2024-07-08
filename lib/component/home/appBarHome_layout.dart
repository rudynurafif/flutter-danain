import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/notifikasi_index.dart';
import 'package:flutter_danain/utils/constants.dart';
import 'package:flutter_danain/widgets/modal/modalBottom.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class AppBarHome extends StatefulWidget {
  final String tkb;
  final bool notif;
  const AppBarHome({
    super.key,
    required this.tkb,
    required this.notif,
  });

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 32, bottom: 12, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/logo/Danain1.svg',
            width: 74,
            height: 28,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              tkbWidget(Constants.get.tkbList),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NotifikasiPage.routeName);
                },
                child: widget.notif
                    ? SvgPicture.asset('assets/images/icons/notif.svg')
                    : const Icon(
                        Icons.notifications,
                        size: 28,
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tkbWidget(List<dynamic> tkbList) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.7,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF1FCF4),
        borderRadius: BorderRadius.circular(40),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider.builder(
            itemCount: tkbList.length,
            itemBuilder: (context, index, realIndex) {
              final tkb = tkbList[realIndex];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'TKB${tkb['tkb']} ',
                            style: const TextStyle(
                              color: Color(0xff288C50),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '= ${tkb['chip']}',
                            style: const TextStyle(
                              color: Color(0XFF288C50),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ModaLBottomTemplate(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: 'TKB ${tkb['tkb']}',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(height: 24),
                                    TextWidget(
                                      text: tkb['subtitle'],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: HexColor('#777777'),
                                    ),
                                    const SizedBox(height: 16),
                                    Image.network(
                                      tkb['image'],
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fitWidth,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.info,
                        color: Color(0xff288C50),
                        size: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 9,
              reverse: false,
              height: 25,
              disableCenter: false,
              enableInfiniteScroll: false,
              viewportFraction: 0.9,
              enlargeFactor: 0.8,
              enlargeCenterPage: true,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24),
            decoration: BoxDecoration(
              color: HexColor('#D7EFDE'),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < tkbList.length; i++)
                  Container(
                    height: 4,
                    width: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? HexColor(primaryColorHex)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
