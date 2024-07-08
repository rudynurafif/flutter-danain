import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/footer_Lisence.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePageLoading extends StatelessWidget {
  const HomePageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          appBarLoading(context),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, BoxConstraints constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: SvgPicture.asset(
                        'assets/images/home/background.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                ),
                SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double pixelRatio = window.devicePixelRatio;
                      double tagWidget = 0;
                      double jualBeli = 0;

                      if (pixelRatio < 1.5) {
                      } else if (pixelRatio >= 1.5 && pixelRatio < 2.0) {
                        jualBeli = 40;
                      } else if (pixelRatio >= 2.0 && pixelRatio < 3.0) {
                        jualBeli = 30;
                      } else {
                        tagWidget = 14;
                        jualBeli = 28;
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: tagWidget),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: tagihanLoading(context),
                          ),
                          SizedBox(height: jualBeli),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: jualBeliLoading(context),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: menuLoading(context),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: produkLoading(context),
                          ),
                          const SizedBox(height: 16),
                          dividerFull5(context),
                          const SizedBox(height: 16),
                          footerLisence(context),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget tagihanLoading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 17),
      decoration: BoxDecoration(
        color: const Color.fromARGB(92, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 11, width: MediaQuery.of(context).size.width),
          const SizedBox(height: 20),
          const ShimmerLong(height: 16, width: 100),
          const SizedBox(height: 20),
          dividerDashed(context),
          const SizedBox(height: 20),
          ShimmerLong(height: 12, width: MediaQuery.of(context).size.width),
          const SizedBox(height: 20),
          ShimmerLong(height: 12, width: MediaQuery.of(context).size.width),
        ],
      ),
    );
  }

  Widget jualBeliLoading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 34,
        bottom: 16,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLong(
                height: 11,
                width: MediaQuery.of(context).size.width / 3,
              ),
              const SizedBox(height: 16),
              ShimmerLong(
                height: 14,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLong(
                height: 11,
                width: MediaQuery.of(context).size.width / 3,
              ),
              const SizedBox(height: 16),
              ShimmerLong(
                height: 14,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ShimmerCircle(height: 56, width: 56),
            const SizedBox(height: 12),
            ShimmerLong(
              height: 11,
              width: MediaQuery.of(context).size.width / 6,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ShimmerCircle(height: 56, width: 56),
            const SizedBox(height: 12),
            ShimmerLong(
              height: 11,
              width: MediaQuery.of(context).size.width / 6,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ShimmerCircle(height: 56, width: 56),
            const SizedBox(height: 12),
            ShimmerLong(
              height: 11,
              width: MediaQuery.of(context).size.width / 6,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ShimmerCircle(height: 56, width: 56),
            const SizedBox(height: 12),
            ShimmerLong(
              height: 11,
              width: MediaQuery.of(context).size.width / 6,
            ),
          ],
        ),
      ],
    );
  }

  Widget appBarLoading(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      titleSpacing: 0,
      title: Align(
        alignment: const Alignment(-0.66, -1.0),
        child: SvgPicture.asset(
          'assets/images/logo/Danain1.svg',
          width: 74,
          height: 28,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            children: [
              const ShimmerLong(height: 28, width: 123),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  size: 20,
                ),
              )
            ],
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor('#E6F5E9'),
                HexColor('#CBEAD4'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget produkLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLong(height: 14, width: MediaQuery.of(context).size.width / 2),
        const SizedBox(height: 16),
        ShimmerLong(height: 105, width: MediaQuery.of(context).size.width),
      ],
    );
  }
}
