import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/modal/modalBottom.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';

class TkbLender extends StatefulWidget {
  const TkbLender({
    super.key,
  });

  @override
  State<TkbLender> createState() => _TkbLenderState();
}

class _TkbLenderState extends State<TkbLender> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: Constants.get.tkbList.length,
            itemBuilder: (context, index, realIndex) {
              final tkb = Constants.get.tkbList.reversed.toList()[realIndex];
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
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '= ${tkb['chip']}',
                            style: const TextStyle(
                              color: Colors.white,
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
                              padding: 24,
                              isUseMark: false,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          text: 'TKB ${tkb['tkb']}',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 24,
                                            color: HexColor('#AAAAAA'),
                                          ),
                                        )
                                      ],
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
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        print('errornya bang $error');
                                        print('stacktrace bang $stackTrace');
                                        return ShimmerLong(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 16,
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
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < Constants.get.tkbList.length; i++)
                  Container(
                    height: 4,
                    width: 12,
                    decoration: BoxDecoration(
                      color: _currentIndex == i ? HexColor(lenderColor) : Colors.transparent,
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
