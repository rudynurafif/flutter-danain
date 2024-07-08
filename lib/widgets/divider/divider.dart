import 'package:flutter/material.dart';

Widget dividerFull(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 16),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xffEEEEEE),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}

class DividerFull extends StatelessWidget {
  final double? paddingTop;

  const DividerFull({super.key, this.paddingTop});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: paddingTop ?? 16),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xffEEEEEE),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

Widget dividerFullnoPad(BuildContext context) {
  return Column(
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xffEEEEEE),
        ),
      ),
    ],
  );
}

Widget dividerFull24(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 24),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xffEEEEEE),
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}

Widget dividerFull5(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 6,
    decoration: const BoxDecoration(
      color: Color(0xffEEEEEE),
    ),
  );
}

Widget dividerFull3(BuildContext context) {
  return Column(
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xffEEEEEE),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget dividerFull2(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 16),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 1,
        decoration: const BoxDecoration(
          color: Color(0xffEEEEEE),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget dividerFull4(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 8),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 1,
        decoration: const BoxDecoration(
          color: Color(0xffEEEEEE),
        ),
      ),
      const SizedBox(height: 8),
    ],
  );
}

Widget dividerFullNoPadding(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 1,
    decoration: const BoxDecoration(
      color: Color(0xffEEEEEE),
    ),
  );
}

Widget dividerDashed(BuildContext context) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashCount = (boxWidth / (2 * 5)).floor();

      return Flex(
        children: List.generate(dashCount, (index) {
          return const SizedBox(
            width: 5,
            height: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      );
    },
  );
}
