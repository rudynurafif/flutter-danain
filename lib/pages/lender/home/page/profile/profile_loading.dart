import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_title_center%202.dart';
import 'package:flutter_danain/widgets/divider/divider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/template/tab.dart';

class ProfileLenderLoading extends StatelessWidget {
  const ProfileLenderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleCenter(context, 'Profile'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
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
                      height: 16,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    const SizedBox(height: 16),
                    ShimmerLong(
                      height: 12,
                      width: MediaQuery.of(context).size.width / 2.5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          dividerFull5(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tabContentLoading(context),
                tabContentLoading(context),
                tabContentLoading(context),
              ],
            ),
          ),
          dividerFull5(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tabContentLoading(context),
                tabContentLoading(context),
              ],
            ),
          ),
          dividerFull5(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tabContentLoading(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
