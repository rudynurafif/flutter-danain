import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

PreferredSizeWidget leftLogoWidget(BuildContext context){
  return AppBar(
    backgroundColor: Colors.white,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.white,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    title: Align(
      alignment: const Alignment(-0.86, -1.0),
      child: SvgPicture.asset(
      'assets/images/logo/Danain1.svg',
      width: 68,
      height: 26,
    ),),
  );
}