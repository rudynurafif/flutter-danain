import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/widgets/divider/divider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';

class SimulasiLoading extends StatelessWidget {
  const SimulasiLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Simulasi Pendanaan'),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              ShimmerLong(
                height: 14,
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 16),
              ShimmerLong4(
                height: kToolbarHeight,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 24),
              ShimmerLong(
                height: 14,
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerLong4(
                    height: 30,
                    width: MediaQuery.of(context).size.width / 2.35,
                  ),
                  ShimmerLong4(
                    height: 30,
                    width: MediaQuery.of(context).size.width / 2.35,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ShimmerLong4(
                height: 18,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 16),
              ShimmerLong4(
                height: kToolbarHeight,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 24),
              resultLoading(context),
              const SizedBox(height: 40),
              ShimmerLong4(
                height: kToolbarHeight,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFF1FCF4),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFDCECE0),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 12, width: MediaQuery.of(context).size.width / 2),
          const SizedBox(height: 16),
          keyValLoading(context),
          const SizedBox(height: 12),
          keyValLoading(context),
          const SizedBox(height: 12),
          keyValLoading(context),
          dividerFull2(context),
          keyValLoading(context),
        ],
      ),
    );
  }

  Widget keyValLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShimmerLong(height: 12, width: MediaQuery.of(context).size.width / 3.5),
        ShimmerLong(height: 12, width: MediaQuery.of(context).size.width / 3.5),
      ],
    );
  }
}
