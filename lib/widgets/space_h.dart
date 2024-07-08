import 'package:flutter/material.dart';
import 'package:flutter_danain/utils/dimens.dart';

class SpacerH extends StatelessWidget {
  const SpacerH({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: value ?? Dimens.space8,
    );
  }
}
