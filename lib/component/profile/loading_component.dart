import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/divider/divider.dart';
import '../../widgets/shimmer/shimmer_widget.dart';
import '../../widgets/template/tab.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                LayoutBuilder(
                  builder: (context, BoxConstraints constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: SvgPicture.asset(
                        'assets/images/home/background.svg',
                        fit: BoxFit.fitWidth,
                        height: 180,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 48,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerCircle(height: 60, width: 60),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLong(
                            height: 18,
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                          const SizedBox(height: 16),
                          ShimmerLong(
                            height: 18,
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                tabContentLoading(context),
                tabContentLoading(context),
                tabContentLoading(context),
                tabContentLoading(context),
                tabContentLoading(context),
              ],
            ),
          ),
          dividerFull5(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: tabContentLoading(context),
          ),
        ],
      ),
    );
  }
}
