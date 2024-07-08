import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../widgets/shimmer/shimmer_widget.dart';
import '../../../../../widgets/text/headline.dart';
import '../../../../../widgets/text/text_widget.dart';

class DetailTitle extends StatelessWidget {
  final String image;
  final String namaProduk;
  final String noPp;
  const DetailTitle({
    super.key,
    required this.image,
    required this.namaProduk,
    required this.noPp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            image,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ShimmerLong(
                height: 56,
                width: 56,
                radius: 8,
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline2500(text: namaProduk),
            const SizedBox(
              height: 4,
            ),
            TextWidget(
              text: 'No. PP $noPp',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: HexColor('#777777'),
            )
          ],
        ),
      ],
    );
  }
}

class DetailTitleLoading extends StatelessWidget {
  const DetailTitleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ShimmerCircle(height: 56, width: 56),
        SizedBox(
          width: 16,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLong(height: 24, width: 256),
            SizedBox(
              height: 4,
            ),
            ShimmerLong(height: 20, width: 256)
          ],
        ),
      ],
    );
  }
}
