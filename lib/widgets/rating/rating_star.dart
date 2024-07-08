import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';

class RatingStar extends StatelessWidget {
  final num rating;
  const RatingStar({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating.toDouble(),
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: HexColor('#FFC600'),
      ),
      itemCount: 5,
      itemSize: 20.0,
      direction: Axis.horizontal,
    );
  }
}
