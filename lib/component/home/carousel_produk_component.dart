import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_danain/pages/borrower/after_login/introduction/introduction_product_page.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/widget_element.dart';

class CarouselProduk extends StatefulWidget {
  const CarouselProduk({super.key});

  @override
  State<CarouselProduk> createState() => _CarouselProdukState();
}

class _CarouselProdukState extends State<CarouselProduk> {
  final images = [
    {
      "image": "assets/images/home/pinjaman_dana.svg",
      "content": 1,
    },
    {
      "image": "assets/images/home/nyicil_emas.svg",
      "content": 2,
    },
  ];
  CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Headline3(text: 'Kenali Produk Danain'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: images.length,
            options: CarouselOptions(
              height: 110,
              autoPlay: true,
              aspectRatio: 16 / 9,
              reverse: false,
              disableCenter: true,
              enableInfiniteScroll: false,
              viewportFraction: 0.9,
              enlargeFactor: 0.8,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                  _carouselController.animateToPage(index);
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final data = images[realIndex];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, IntroductionProductAfterLogin.routeName,
                      arguments: IntroductionProductAfterLogin(
                        content: data['content'] as int,
                      ));
                },
                child: Container(
                  padding: realIndex == 0
                      ? const EdgeInsets.only(right: 10)
                      : const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width,
                  child: SvgPicture.asset(
                    data['image'] as String,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < images.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = i;
                    _carouselController.animateToPage(i);
                  });
                },
                child: Container(
                  height: _currentIndex == i ? 8 : 6,
                  width: _currentIndex == i ? 8 : 6,
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
        ),
      ],
    );
  }
}
