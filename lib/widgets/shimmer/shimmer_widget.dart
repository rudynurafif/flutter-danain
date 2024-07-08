import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLong extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  const ShimmerLong({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          color: Colors.white,
        ),
        width: width,
        height: height,
      ),
    );
  }
}

class ShimmerLong4 extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerLong4({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
        ),
        width: width,
        height: height,
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerCircle({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.white,
        ),
        width: width,
        height: height,
      ),
    );
  }
}
