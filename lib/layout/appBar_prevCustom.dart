import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

PreferredSizeWidget previousCustomWidget(
    BuildContext context, VoidCallback action) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.white,
    leading: IconButton(
      onPressed: action,
      icon: SvgPicture.asset('assets/images/icons/back.svg'),
    ),
  );
}
