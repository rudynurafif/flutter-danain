import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/divider/divider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailPinjamanLoading extends StatelessWidget {
  const DetailPinjamanLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageDetailLoading(context),
          totalLoading(context),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: detailPinjamanLoading(context),
          ),
          dividerFull(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: agunanLoading(context),
          ),
          dividerFull(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: totalPelunasanLoading(context),
          ),
          dividerFull(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: dokumenPerjanjianLoading(context),
          ),
          dividerFull(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: waktuPengajuanLoading(context),
          ),
          dividerFull(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: penjualanAgunanLoading(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget imageDetailLoading(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: ShimmerLong4(
            height: 200,
            width: MediaQuery.of(context).size.width,
          ),
        );
      },
    );
  }

  Widget totalLoading(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: HexColor('#E9F6EB')),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShimmerLong(height: 18, width: 100),
          SizedBox(height: 8),
          ShimmerLong(height: 27, width: 180),
        ],
      ),
    );
  }

  Widget detailPinjamanLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Positioned(
              top: 40,
              child: dividerFull2(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailDataLoading(context),
                    const SizedBox(height: 24),
                    detailDataLoading(context),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailDataLoading(context),
                    const SizedBox(height: 24),
                    detailDataLoading(context),
                  ],
                ),
                detailDataLoading(context),
              ],
            ),
          ],
        ),
        dividerFull2(context),
        detailDataLoading(context),
      ],
    );
  }

  Widget detailDataLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLong(
          height: 17,
          width: MediaQuery.of(context).size.width / 3.5,
        ),
        const SizedBox(height: 8),
        ShimmerLong(
          height: 17,
          width: MediaQuery.of(context).size.width / 3.5,
        ),
      ],
    );
  }

  Widget agunanLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerLong(
          height: 24,
          width: MediaQuery.of(context).size.width / 2,
        ),
        const ShimmerCircle(height: 24, width: 24)
      ],
    );
  }

  Widget totalPelunasanLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLong(
              height: 18,
              width: MediaQuery.of(context).size.width / 3,
            ),
            const SizedBox(height: 4),
            ShimmerLong(
              height: 24,
              width: MediaQuery.of(context).size.width / 2,
            ),
          ],
        ),
        const ShimmerCircle(height: 24, width: 24)
      ],
    );
  }

  Widget dokumenPerjanjianLoading(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLong(height: 24, width: MediaQuery.of(context).size.width / 2.1),
        const SizedBox(height: 8),
        ShimmerLong4(height: 32, width: MediaQuery.of(context).size.width),
      ],
    );
  }

  Widget waktuPengajuanLoading(BuildContext context) {
    return Wrap(
      spacing: MediaQuery.of(context).size.width / 5,
      children: [
        detailDataLoading(context),
        detailDataLoading(context),
      ],
    );
  }

  Widget penjualanAgunanLoading(BuildContext context) {
    return ShimmerLong4(height: 45, width: MediaQuery.of(context).size.width);
  }
}
