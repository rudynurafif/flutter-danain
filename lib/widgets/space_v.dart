import 'package:flutter/material.dart';
import 'package:flutter_danain/utils/dimens.dart';

class SpacerV extends StatelessWidget {
  const SpacerV({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: value ?? Dimens.space8,
    );
  }
}
