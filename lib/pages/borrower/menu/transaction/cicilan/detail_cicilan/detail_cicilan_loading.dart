import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailCicilanLoading extends StatelessWidget {
  const DetailCicilanLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          detailLoading(context),
          dividerFull(context),
          mitraLoading(context),
          dividerFull(context),
          detailEmasLoading(context),
          listEmasLoading(context),
          dividerFull(context),
          footerLoading(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget detailLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 21, width: MediaQuery.of(context).size.width / 1.5),
          const SizedBox(height: 8),
          keyValLoading(context),
          const SizedBox(height: 8),
          keyValLoading(context),
          const SizedBox(height: 8),
          keyValLoading(context),
          const SizedBox(height: 8),
          keyValLoading(context),
          const SizedBox(height: 8),
          keyValLoading(context),
        ],
      ),
    );
  }

  Widget mitraLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(
            height: 21,
            width: MediaQuery.of(context).size.width / 1.5,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerCircle(height: 30, width: 30),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(
                    height: 21,
                    width: MediaQuery.of(context).size.width / 1.3,
                  ),
                  const SizedBox(height: 4),
                  ShimmerLong4(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.3,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget listEmasLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ShimmerLong4(height: 18, width: 18),
                  const SizedBox(width: 8),
                  ShimmerLong(
                    height: 20,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
              ShimmerLong(
                height: 18,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listLoading(context),
                listLoading(context),
                listLoading(context),
              ]),
          dividerDashed(context),
          const SizedBox(height: 16),
          keyValLoading(context),
        ],
      ),
    );
  }

  Widget listLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: HexColor('#EEEEEE'),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ShimmerLong4(height: 32, width: 32),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLong(
                height: 20,
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 4),
              ShimmerLong(
                height: 20,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget footerLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          keyValLoading(context),
          const SizedBox(height: 16),
          ShimmerLong4(height: 113, width: MediaQuery.of(context).size.width),
          const SizedBox(height: 16),
          keyValLoading(context),
        ],
      ),
    );
  }

  Widget detailEmasLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShimmerLong(height: 21, width: MediaQuery.of(context).size.width / 2),
          const ShimmerCircle(height: 24, width: 24),
        ],
      ),
    );
  }
}
