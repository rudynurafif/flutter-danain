import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class Step1LoadingTarikDana extends StatelessWidget {
  const Step1LoadingTarikDana({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          saldoLoading(context),
          const SizedBox(height: 16),
          textFieldLoading(context),
          dividerFull(context),
          rekeningLoading(context),
          dividerFull(context),
          syaratKetentuanLoading(context)
        ],
      ),
    );
  }

  Widget saldoLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: HexColor('#F5F9F6'),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ShimmerCircle(height: 40, width: 40),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLong(
                height: 14,
                width: MediaQuery.of(context).size.width / 3,
              ),
              const SizedBox(height: 4),
              ShimmerLong(
                height: 14,
                width: MediaQuery.of(context).size.width / 2,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget textFieldLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(
            height: 12,
            width: MediaQuery.of(context).size.width / 2,
          ),
          const SizedBox(height: kToolbarHeight),
          ShimmerLong4(
            height: 12,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 8),
          ShimmerLong(
            height: 12,
            width: MediaQuery.of(context).size.width,
          )
        ],
      ),
    );
  }

  Widget rekeningLoading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Subtitle3(
            text: 'Rekening Tujuan:',
            color: HexColor('#AAAAAA'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ShimmerCircle(height: 42, width: 42),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLong(
                        height: 12,
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      const SizedBox(height: 4),
                      ShimmerLong(
                        height: 12,
                        width: MediaQuery.of(context).size.width / 2.5,
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget syaratKetentuanLoading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 14, width: MediaQuery.of(context).size.width),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerCircle(height: 8, width: 8),
              const SizedBox(width: 8),
              ShimmerLong4(
                height: 60,
                width: MediaQuery.of(context).size.width / 1.2,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerCircle(height: 8, width: 8),
              const SizedBox(width: 8),
              ShimmerLong4(
                height: 60,
                width: MediaQuery.of(context).size.width / 1.2,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerCircle(height: 8, width: 8),
              const SizedBox(width: 8),
              ShimmerLong4(
                height: 60,
                width: MediaQuery.of(context).size.width / 1.2,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
