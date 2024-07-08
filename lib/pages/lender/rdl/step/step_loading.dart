import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';

class StepLoadingRdl extends StatelessWidget {
  const StepLoadingRdl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Data Pribadi'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              ShimmerLong4(
                height: 75,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 16),
              formLoading(context),
              const SizedBox(height: 16),
              formLoading(context),
              const SizedBox(height: 16),
              formLoading(context),
              const SizedBox(height: 16),
              formLoading(context),
              const SizedBox(height: 16),
              formLoading(context),
              const SizedBox(height: 16),
              formLoading(context),
              const SizedBox(height: 16),
              formLoading(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget formLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLong(
          height: 17,
          width: MediaQuery.of(context).size.width / 3,
        ),
        const SizedBox(height: 4),
        ShimmerLong(
          height: kToolbarHeight,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
