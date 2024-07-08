import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class Step2Loading extends StatelessWidget {
  const Step2Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ShimmerLong4(height: 42, width: 42),
              const SizedBox(width: 16),
              ShimmerLong(
                width: MediaQuery.of(context).size.width / 3,
                height: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: virtualAccountLoading(context),
        ),
        dividerFull24(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: caraSetorLoading(context),
        )
      ],
    );
  }

  Widget virtualAccountLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLong(
          width: MediaQuery.of(context).size.width / 2,
          height: 11,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerLong(
              height: 14,
              width: MediaQuery.of(context).size.width / 2,
            ),
            const ShimmerLong4(height: 18, width: 54)
          ],
        )
      ],
    );
  }

  Widget caraSetorLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerLong(
              height: 14,
              width: MediaQuery.of(context).size.width / 2,
            ),
            const ShimmerCircle(height: 16, width: 16),
          ],
        ),
        const SizedBox(height: 16),
        ShimmerLong(
          height: 14,
          width: MediaQuery.of(context).size.width / 2,
        ),
        const SizedBox(height: 16),
        ShimmerLong(
          height: 14,
          width: MediaQuery.of(context).size.width / 2,
        ),
        const SizedBox(height: 16),
        ShimmerLong(
          height: 14,
          width: MediaQuery.of(context).size.width / 2,
        ),
      ],
    );
  }
}
