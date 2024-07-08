import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class SimulasiCicilanLoading extends StatelessWidget {
  const SimulasiCicilanLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Simulasi Cicilan Emas'),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dataEmasLoading(context),
              dividerFull(context),
              jangkaWaktuLoading(context),
              dividerFull(context),
              simulasiLoading(context),
              dividerFull(context),
              annoutcementLoading(context),
              const SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }

  Widget dataEmasLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 21, width: MediaQuery.of(context).size.width / 3),
          const SizedBox(height: 12),
          ShimmerLong(height: 24, width: MediaQuery.of(context).size.width / 2),
        ],
      ),
    );
  }

  Widget jangkaWaktuLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 21, width: MediaQuery.of(context).size.width / 2),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerLong4(
                height: 30,
                width: MediaQuery.of(context).size.width / 4,
              ),
              ShimmerLong4(
                height: 30,
                width: MediaQuery.of(context).size.width / 4,
              ),
              ShimmerLong4(
                height: 30,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget simulasiLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 21, width: MediaQuery.of(context).size.width / 2),
          const SizedBox(height: 12),
          ShimmerLong4(height: 90, width: MediaQuery.of(context).size.width),
        ],
      ),
    );
  }

  Widget annoutcementLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong4(height: 90, width: MediaQuery.of(context).size.width),
        ],
      ),
    );
  }
}
