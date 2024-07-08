  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_svg/flutter_svg.dart';
PreferredSizeWidget logoPreviousWidget(BuildContext context){
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.white,
    leading: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, PreferencePage.routeName);
        },
        icon: SvgPicture.asset('assets/images/icons/back.svg'),),
    title: SvgPicture.asset(
      "assets/images/logo/Danain1.svg",
      width: 65,
      height: 24,
    ),
    centerTitle: true,
  );

}