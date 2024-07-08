import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../pages/borrower/after_login/pencairan/detail_pencairan/detail_pencairan_page.dart';
import '../../utils/string_format.dart';
import 'verif_component.dart';

class PenawaranPencairan extends StatefulWidget {
  final List<dynamic> dataHome;

  const PenawaranPencairan({super.key, required this.dataHome});

  @override
  State<PenawaranPencairan> createState() => _PenawaranPencairanState();
}

class _PenawaranPencairanState extends State<PenawaranPencairan> {
  final CarouselController _carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Headline3(text: 'Proses Pencairan'),
            ),
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 208,
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: widget.dataHome.length,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  reverse: false,
                  disableCenter: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.92,
                  enlargeFactor: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                      _carouselController.animateToPage(index);
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final data = widget.dataHome[realIndex];
                  final List<dynamic> items = data['detail_jaminan'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, DetailPencairanPage.routeName,
                          arguments: DetailPencairanPage(
                            idjaminan: data['id_jaminan'],
                            idproduk: data['idproduk'],
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: HexColor('#DAF1DE'),
                        ),
                        color: HexColor('#F9FFFA'),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: HexColor('#E9F6EB'),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/home/maxi.svg',
                                      ),
                                      const SizedBox(width: 8),
                                      Subtitle2Extra(
                                        text: data['nama_produk'].toString(),
                                      ),
                                    ],
                                  ),
                                ),
                                Subtitle2(
                                  text: data['no_perjanjian_pinjaman'].toString(),
                                  color: HexColor('#777777'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Subtitle3(
                                      text: 'Jumlah Pinjaman',
                                      color: HexColor('#AAAAAA'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: HexColor('#FEF4E8'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Subtitle3(
                                            text: 'Proses',
                                            color: HexColor('#F7951D'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Headline2(text: rupiahFormat(data['jumlah_pinjaman'])),
                                dividerFull2(context),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Subtitle3(
                                          text: 'Nama Mitra',
                                          color: HexColor('#AAAAAA'),
                                        ),
                                        const SizedBox(height: 4),
                                        Subtitle2Extra(
                                          text: shortText(data['nama_mitra'], 16),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Subtitle3(
                                          text: 'Berat',
                                          color: HexColor('#AAAAAA'),
                                        ),
                                        const SizedBox(height: 4),
                                        Subtitle2Extra(
                                          text: shortenText(
                                              items.map((val) => '${val['berat']}G').join(',')),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Subtitle3(
                                          text: 'Karat',
                                          color: HexColor('#AAAAAA'),
                                        ),
                                        const SizedBox(height: 4),
                                        Subtitle2Extra(
                                          text: shortenText(
                                              items.map((val) => '${val['karat']}k').join(',')),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
