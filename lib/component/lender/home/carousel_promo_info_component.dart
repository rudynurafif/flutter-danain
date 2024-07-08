import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman.page.dart';
import 'package:flutter_svg/svg.dart';

import '../../../widgets/text/headline.dart';

class CaraouselPromoInfoComponent extends StatefulWidget {
  final HomeBloc homeBloc;
  const CaraouselPromoInfoComponent({super.key, required this.homeBloc});
  @override
  State<CaraouselPromoInfoComponent> createState() => _CaraouselPromoInfoComponentState();
}

class _CaraouselPromoInfoComponentState extends State<CaraouselPromoInfoComponent> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: widget.homeBloc.listInfoPromoStream$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listData = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Set background color to white
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Static text with padding
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Headline3500(text: 'Info dan Promo Danain'),
                    ),
                    const SizedBox(height: 12),
                    // CarouselSlider widget displaying a list of images
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider.builder(
                        carouselController: _carouselController,
                        itemCount: listData.length,
                        options: CarouselOptions(
                          // Carousel options such as height, autoPlay, etc.
                          height: 180,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          reverse: false,
                          disableCenter: true,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.9,
                          enlargeFactor: 0.8,
                          onPageChanged: (index, reason) {
                            // Update the current index when the page changes
                            setState(() {
                              _currentIndex = index;
                              _carouselController.animateToPage(index);
                            });
                          },
                        ),
                        itemBuilder: (context, index, realIndex) {
                          // Build each item in the carousel
                          final data = listData[realIndex];
                          return GestureDetector(
                            onTap: () {
                              if(data['tnama_image_benner'] == 'Ajak Teman'){
                                Navigator.pushNamed(context, AjakTemanPage.routeName);
                              }
                              // Navigate to another screen on tap, passing arguments
                            },
                            child: Container(
                              padding: realIndex == 0
                                  ? const EdgeInsets.only(right: 10)
                                  : const EdgeInsets.only(left: 10),
                              height: 120,
                              width: 244,
                              child: data['turl_image_benner'].toString().endsWith('.svg')
                                  ? SvgPicture.network(
                                data['turl_image_benner'] as String,
                                fit: BoxFit.fitWidth,
                              )
                                  : Image.network(
                                data['turl_image_benner'] as String,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Row of indicators (dots) to indicate the current page in the carousel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < listData.length; i++)
                          GestureDetector(
                            onTap: () {
                              // Update the current index on dot tap
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
                ),
              ),
            ],
          );

        } else if (snapshot.hasError) {
          // Handle the error case if needed
          return Text('Error: ${snapshot.error}');
        } else {
          // Handle the case when there's no data yet
          return Container(); // or some other loading indicator
        }
      },
    );
  }


}
