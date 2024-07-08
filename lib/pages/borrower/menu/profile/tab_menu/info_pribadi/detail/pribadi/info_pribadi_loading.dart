import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class BorrowerLoading extends StatelessWidget {
  const BorrowerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            ShimmerLong4(height: 58, width: MediaQuery.of(context).size.width),
            const SizedBox(height: 24),
            const Headline3500(text: 'Data Diri'),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            const Headline3500(text: 'Informasi Tambahan'),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            const Headline3500(text: 'Alamat Sesuai KTP'),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
            keyValVerticalLoading(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class LenderLoading extends StatelessWidget {
  const LenderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLong4(
                      height: 58,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(height: 24),
                    const Headline3500(text: 'Data Pribadi'),
                    const SizedBox(height: 16),
                    keyValVerticalLoading(context),
                    const SizedBox(height: 16),
                    keyValVerticalLoading(context),
                    const SizedBox(height: 16),
                    keyValVerticalLoading(context),
                    const SizedBox(height: 16),
                    keyValVerticalLoading(context),
                    const SizedBox(height: 16),
                    keyValVerticalLoading(context),
                    const SizedBox(height: 16),
                    keyValVerticalLoading(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              dividerFull(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      const Headline3500(text: 'Data Alamat'),
                      const SizedBox(height: 16),
                      keyValVerticalLoading(context),
                      const SizedBox(height: 16),
                      keyValVerticalLoading(context),
                      const SizedBox(height: 16),
                      keyValVerticalLoading(context),
                      const SizedBox(height: 16),
                      keyValVerticalLoading(context),
                      const SizedBox(height: 16),
                      keyValVerticalLoading(context),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Add more widgets if needed
        ],
      ),
    );
  }
}
