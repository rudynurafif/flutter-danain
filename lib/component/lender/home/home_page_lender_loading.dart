import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePageLenderLoading extends StatelessWidget {
  const HomePageLenderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F5F9F6'),
      appBar: appBarLoading(context),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/lender/home/background.svg',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ShimmerLong(
                    height: 16,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
                const SizedBox(height: 16),
                saldoLoading(context),
                const SizedBox(height: 16),
                menuLoading(context),
                const SizedBox(height: 16),
                infoLoading(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget appBarLoading(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: HexColor(lenderColor),
      title: SvgPicture.asset(
        'assets/images/logo/danain2.svg',
        width: 74,
        height: 28,
        fit: BoxFit.contain,
      ),
      elevation: 0,
      actions: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: ShimmerLong(height: 24, width: 123),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget saldoLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerLong(height: 11, width: 120),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShimmerLong(
                  height: 16,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                const ShimmerCircle(height: 20, width: 20),
              ],
            ),
            const SizedBox(height: 16),
            dividerFullNoPadding(context),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLong(
                      height: 10,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    const SizedBox(height: 8),
                    ShimmerLong(
                      height: 12,
                      width: MediaQuery.of(context).size.width / 3,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLong(
                      height: 10,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    const SizedBox(height: 8),
                    ShimmerLong(
                      height: 12,
                      width: MediaQuery.of(context).size.width / 3,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget menuLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ShimmerCircle(height: 48, width: 48),
                const SizedBox(height: 12),
                ShimmerLong(
                  height: 9,
                  width: MediaQuery.of(context).size.width / 6,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ShimmerCircle(height: 48, width: 48),
                const SizedBox(height: 12),
                ShimmerLong(
                  height: 9,
                  width: MediaQuery.of(context).size.width / 6,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ShimmerCircle(height: 48, width: 48),
                const SizedBox(height: 12),
                ShimmerLong(
                  height: 9,
                  width: MediaQuery.of(context).size.width / 6,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ShimmerCircle(height: 48, width: 48),
                const SizedBox(height: 12),
                ShimmerLong(
                  height: 9,
                  width: MediaQuery.of(context).size.width / 6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 14, width: MediaQuery.of(context).size.width / 2),
          const SizedBox(height: 16),
          ShimmerLong(height: 105, width: MediaQuery.of(context).size.width),
        ],
      ),
    );
  }
}
