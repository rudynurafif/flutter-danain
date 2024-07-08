import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/divider/divider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:hexcolor/hexcolor.dart';

class PortfolioLoading extends StatelessWidget {
  const PortfolioLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return ShimmerLong4(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShimmerLong(
                          height: 17,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        const SizedBox(height: 8),
                        ShimmerLong(
                          height: 17,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 45,
                    width: 2,
                    color: HexColor('#EEEEEE'),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShimmerLong(
                          height: 17,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        const SizedBox(height: 8),
                        ShimmerLong(
                          height: 17,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            dividerFull(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(
                    height: 14,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  const SizedBox(height: 8),
                  ShimmerLong(
                    height: 24,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                          const SizedBox(height: 4),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                          const SizedBox(height: 8),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                          const SizedBox(height: 4),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                          const SizedBox(height: 4),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                          const SizedBox(height: 8),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                          const SizedBox(height: 4),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                          const SizedBox(height: 4),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3.6,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            dividerFull(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerLong(
                    height: 17,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  const ShimmerCircle(height: 24, width: 24),
                ],
              ),
            ),
            dividerFull(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(
                    height: 21,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  const SizedBox(height: 8),
                  ShimmerLong(
                    height: 18,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
            dividerFull(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(
                    height: 21,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                          const SizedBox(height: 8),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                        ],
                      ),
                      const SizedBox(width: 70),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                          const SizedBox(height: 8),
                          ShimmerLong(
                            height: 17,
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
