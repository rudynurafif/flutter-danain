import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/route_main/onboarding.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );

  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;
  List<Map<String, dynamic>> images = [
    {
      'images': 'assets/images/onboarding/lender.png',
      'route': OnboardingMaster.routeName,
      'title': 'Pendana',
      'subtitle': 'Sebagai pemberi pinjaman',
      'user': 1,
    },
    {
      'images': 'assets/images/onboarding/peminjam.png',
      'route': OnboardingMaster.routeName,
      'title': 'Peminjam',
      'subtitle': 'Sebagai peminjam',
      'user': 2,
    },
  ];

  CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: Headline1(
                text: 'Pilih  Preferensi Anda',
                align: TextAlign.start,
              ),
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: Subtitle2(
                text:
                    'Mohon pilih preferensi sesuai tujuan Anda\nmenggunakan Danain',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.9,
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 400,
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
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  final data = images[realIndex];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = realIndex;
                        _carouselController.animateToPage(realIndex);
                      });
                    },
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                data['images']!,
                                fit: BoxFit.cover,
                                width: 269,
                                height: 373,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data['title']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data['subtitle']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    width: 167,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await rxPrefs.setInt(
                                          'user_status',
                                          data['user'],
                                        );
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   OnboardingMaster.routeName,
                                        // );
                                        Navigator.pushNamed(
                                          context,
                                          data['route'],
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                data['title']! == 'Peminjam'
                                                    ? Colors.orange
                                                    : Colors.green),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Pilih',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
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
        ),
      ),
    );
  }
}
