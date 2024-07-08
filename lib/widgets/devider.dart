import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double height;
  final double? width;
  final Color color;
  final bool isDashed;
  const DividerWidget({
    super.key,
    required this.height,
    this.width,
    this.isDashed = false,
    this.color = const Color(0xffEEEEEE),
  });

  @override
  Widget build(BuildContext context) {
    if (isDashed) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashCount = (boxWidth / (2 * 5)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (index) {
              return SizedBox(
                width: 5,
                height: height,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xffDDDDDD)),
                ),
              );
            }),
          );
        },
      );
    }
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      color: color,
    );
  }
}
